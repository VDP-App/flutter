import 'package:flutter/material.dart';
import 'package:vdp/widgets/make_entry/display/stock.dart';
import 'package:vdp/widgets/make_entry/keybord/builder.dart';
import 'package:vdp/widgets/selectors/select_stock_changes.dart';
import 'package:vdp/documents/config.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/stock.dart';
import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/stock_changes.dart';
import 'package:vdp/providers/make_entries/custom/item.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';

const _fN0 = FixedNumber(text: "", val: 0);

abstract class Stocking<T extends Changes> extends Modal with ChangeNotifier {
  StockDoc? _stockDoc;
  final String _stockID;

  var _focusedAt = Focuses.itemNum;
  var _lastKeyPressed = KeybordKeyValue.enter;
  FixedNumber _currentQuntity = _fN0;
  final ItemCode _itemCode = ItemCode();
  final List<T> _changes = [];
  var _loading = false;
  bool get loading => _loading;

  Stocking(BuildContext context, this._stockID) : super(context);

  void update(
    StockDoc stockDoc,
    ProductDoc items,
  ) {
    _itemCode.update(items);
    _stockDoc = stockDoc;
    notifyListeners();
  }

  void _applyChanges(String? note);

  void _updateCurrentQuntity() {
    _currentQuntity =
        (_stockDoc as StockDoc).currentStock[_itemCode.item?.id] ?? _fN0;
  }

  void _onStockChangeSelect(T stockChanges) {
    _changes.remove(stockChanges);
    _itemCode.changeItemTo(stockChanges.item);
    _currentQuntity = stockChanges.currentQuntity;
  }

  void openStockChanges() {
    if (_changes.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ShowStockChanges<T>(
            changes: _changes,
            onChangesSelect: _onStockChangeSelect,
            deleteChanges: (stockChanges) {
              _changes.remove(stockChanges);
              _reset();
            },
          );
        }),
      ).then((value) => notifyListeners());
    }
  }

  void resetItemCode() {
    _reset();
    notifyListeners();
  }

  void _reset([Product? item]) {
    if (item == null) _itemCode.changeCodeTo("");
    _currentQuntity = _fN0;
    _focusedAt = Focuses.itemNum;
  }

  void openItemSelector() {
    _itemCode
        .openItemSelector(context, _reset)
        .then((value) => notifyListeners());
  }

  void _addChanges() {
    _reset();
  }

  void _onClick(KeybordKeyValue action) {
    switch (action) {
      case KeybordKeyValue.enter:
        if (_lastKeyPressed == KeybordKeyValue.enter && !_itemCode.hasItem) {
          if (_changes.isNotEmpty) {
            this is StockSetting
                ? getName("Add a note to remember").then((note) {
                    if (note == null) return;
                    shouldProceed("Apply Changes").then((x) {
                      if (!x) return;
                      _applyChanges(note);
                      notifyListeners();
                    });
                  })
                : shouldProceed("Apply Changes").then((x) {
                    if (!x) return;
                    _applyChanges(null);
                    notifyListeners();
                  });
          }
        } else if (_focusedAt != Focuses.itemNum) {
          _addChanges();
        }
        break;
      case KeybordKeyValue.esc:
        if (_itemCode.isEmpty) {
          if (_changes.isNotEmpty) {
            shouldProceed("Clear all Changes").then((x) {
              if (x) {
                _changes.clear();
                notifyListeners();
              }
            });
          }
        }
        _reset();
        break;
      case KeybordKeyValue.action1:
        _onAction1Press();
        break;
      case KeybordKeyValue.action2:
        _onAction2Press();
        break;
      case KeybordKeyValue.action3:
        _onAction3Press();
        break;
      case KeybordKeyValue.period:
        _onPeriodPress();
        break;
      default:
        var number = action.num;
        if (number != null) {
          _onNumberPress(number);
        }
        break;
    }
  }

  bool _onNumberPress(String number) {
    if (_focusedAt != Focuses.itemNum) return false;
    _itemCode.changeCodeTo(_itemCode + number);
    if (_itemCode.hasItem) _updateCurrentQuntity();
    return true;
  }

  void _onPeriodPress();

  void _onAction3Press();

  void _onAction2Press();

  void _onAction1Press();

  void _processAction_2_3() {
    final itemId = _itemCode.item?.id;
    if (itemId == null) return;
    _changes.removeWhere((e) => e.itemId == itemId);
  }

  void onClick(KeybordKeyValue action) async {
    if (_stockDoc == null || _loading) return;
    _onClick(action);
    _lastKeyPressed = action;
    notifyListeners();
  }

  Focuses get focusedAt => _focusedAt;
  String get itemNum => _itemCode.code;
  String get name => _itemCode.name;
  String get currentQuntity => _currentQuntity.text;
  String get addedQuntity;
  String get setQuntity;
  int get length => _changes.length;
}

class StockSetting extends Stocking<StockSettingChanges> {
  final _addedQuntity = Number();
  final _setQuntity = Number();
  final _stockChangesOnCloud = StockChangesOnCloud();
  StockSetting(BuildContext context, String stockID) : super(context, stockID);

  @override
  void update(StockDoc stockDoc, ProductDoc items) {
    final product = _itemCode.item;
    if (product != null) {
      final p = items.getItemBy(id: product.id);
      if (p == null || p.isDeleted || p.code != product.code) _reset();
      _currentQuntity = stockDoc.currentStock[_itemCode.item?.id] ?? _fN0;
      if (_focusedAt == Focuses.addQuntity) {
        _updateAddedQuntity("", _addedQuntity.val);
      } else if (_focusedAt == Focuses.setQuntity) {
        _updateAddedQuntity("", _setQuntity.val);
      }
    }
    var i = 0;
    for (var change in _changes) {
      if (items[change.itemId]?.isDeleted ?? true) {
        _changes.removeAt(i);
        continue;
      }
      final newCurrentQuntity = stockDoc.currentStock[change.itemId] ?? _fN0;
      if (change.currentQuntity.val != newCurrentQuntity.val) {
        if (change.isSetStock) {
          _changes[i] = StockSettingChanges(
            addedQuntity:
                FixedNumber.fromInt(change.setQuntity - newCurrentQuntity),
            currentQuntity: newCurrentQuntity,
            isSetStock: true,
            itemId: change.itemId,
            setQuntity: change.setQuntity,
          );
        } else {
          _changes[i] = StockSettingChanges(
            setQuntity:
                FixedNumber.fromInt(change.addedQuntity + newCurrentQuntity),
            currentQuntity: newCurrentQuntity,
            isSetStock: false,
            itemId: change.itemId,
            addedQuntity: change.addedQuntity,
          );
        }
      }
      i++;
    }
    super.update(stockDoc, items);
  }

  void _updateSetQuntity(String digit, [int? val, bool negat = false]) {
    if (negat) {
      _setQuntity.negate();
    } else if (val == null) {
      _setQuntity.appendDigit(digit);
    } else {
      _setQuntity.val = val;
    }
    _addedQuntity.val = _setQuntity - _currentQuntity;
  }

  void _updateAddedQuntity(String digit, [int? val, bool negat = false]) {
    if (negat) {
      _addedQuntity.negate();
    } else if (val == null) {
      _addedQuntity.appendDigit(digit);
    } else {
      _addedQuntity.val = val;
    }
    _setQuntity.val = _currentQuntity + _addedQuntity;
  }

  @override
  void _applyChanges(String? note) async {
    _loading = true;
    notifyListeners();
    await handleCloudCall(
      _stockChangesOnCloud.makeChanges(StockChanges(
        [..._changes],
        _stockID,
        note,
      )),
    );
    _changes.clear();
    _loading = false;
    notifyListeners();
  }

  @override
  void _updateCurrentQuntity() {
    _currentQuntity =
        (_stockDoc as StockDoc).currentStock[_itemCode.item?.id] ?? _fN0;
  }

  @override
  void _onStockChangeSelect(StockSettingChanges stockChanges) {
    super._onStockChangeSelect(stockChanges);
    _addedQuntity.assign(stockChanges.addedQuntity);
    _setQuntity.assign(stockChanges.setQuntity);
    _focusedAt =
        stockChanges.isSetStock ? Focuses.setQuntity : Focuses.addQuntity;
  }

  @override
  void _reset([Product? item]) {
    super._reset(item);
    _addedQuntity.val = 0;
    _setQuntity.val = 0;
  }

  @override
  void _addChanges() {
    final item = _itemCode.item;
    if (item == null) return;
    _changes.add(StockSettingChanges(
      isSetStock: _focusedAt == Focuses.setQuntity,
      itemId: item.id,
      addedQuntity: _addedQuntity.toFixedNumber(),
      currentQuntity: _currentQuntity,
      setQuntity: _setQuntity.toFixedNumber(),
    ));
    super._addChanges();
  }

  @override
  void _onPeriodPress() {
    if (_focusedAt == Focuses.addQuntity) {
      _addedQuntity.periodPress();
      _setQuntity.val = _currentQuntity + _addedQuntity;
    } else if (_focusedAt == Focuses.setQuntity) {
      _setQuntity.periodPress();
      _addedQuntity.val = _setQuntity - _currentQuntity;
    }
  }

  @override
  bool _onNumberPress(String number) {
    if (super._onNumberPress(number)) return true;
    if (_focusedAt == Focuses.addQuntity) {
      _updateAddedQuntity(number);
    } else {
      _updateSetQuntity(number);
    }
    return true;
  }

  @override
  void _onAction3Press() {
    if (_itemCode.hasItem) {
      _processAction_2_3();
      _focusedAt = Focuses.setQuntity;
      _updateSetQuntity("", 0);
    }
  }

  @override
  void _onAction2Press() {
    if (_itemCode.hasItem) {
      _processAction_2_3();
      _focusedAt = Focuses.addQuntity;
      _updateAddedQuntity("", 0);
    }
  }

  @override
  void _onAction1Press() {
    if (_focusedAt == Focuses.addQuntity) {
      _updateAddedQuntity("", 0, true);
    } else if (_focusedAt == Focuses.setQuntity) {
      _updateSetQuntity("", 0, true);
    }
  }

  @override
  String get addedQuntity => _addedQuntity.text;

  @override
  String get setQuntity => _setQuntity.text;
}

class TransferStock extends Stocking<TransferStockChanges> {
  final _sendQuntity = Number();
  final _afterSendQuntity = Number();
  final _transferStockOnCloud = TransferStockOnCloud();
  ConfigDoc? _configDoc;
  TransferStock(BuildContext context, String stockID) : super(context, stockID);

  void updateTransfer(
    StockDoc stockDoc,
    ProductDoc items,
    ConfigDoc configDoc,
  ) {
    _configDoc = configDoc;
    update(stockDoc, items);
  }

  @override
  void update(StockDoc stockDoc, ProductDoc items) {
    final product = _itemCode.item;
    if (product != null) {
      final p = items.getItemBy(id: product.id);
      if (p == null || p.isDeleted || p.code != product.code) _reset();
      _currentQuntity = stockDoc.currentStock[_itemCode.item?.id] ?? _fN0;
      _updateSendQuntity("", _sendQuntity.val);
    }
    var i = 0;
    for (var change in _changes) {
      if (items[change.itemId]?.isDeleted ?? true) {
        _changes.removeAt(i);
        continue;
      }
      final newCurrentQuntity = stockDoc.currentStock[change.itemId] ?? _fN0;
      if (change.currentQuntity.val != newCurrentQuntity.val) {
        _changes[i] = TransferStockChanges(
          currentQuntity: newCurrentQuntity,
          afterSendQuntity:
              FixedNumber.fromInt(newCurrentQuntity - change.sendQuntity),
          itemId: change.itemId,
          sendQuntity: change.sendQuntity,
        );
      }
      i++;
    }
    super.update(stockDoc, items);
  }

  @override
  void _applyChanges(String? note) async {
    var stocks = _configDoc?.stocks;
    if (stocks == null) return;
    stocks = [...stocks];
    stocks.removeWhere((e) => e.id == _stockID);
    if (stocks.isEmpty) return;
    _loading = true;
    notifyListeners();
    final sendStockId = stocks.length == 1
        ? stocks.first.id
        : await selectOne<StockInfo>(
            title: "Stock",
            currentlySelected: null,
            modalListElement: stocks,
            onSelect: (x) {},
          );
    if (sendStockId != null) {
      await handleCloudCall(_transferStockOnCloud.sendTransfer(
        sendStockId,
        StockChanges([..._changes], _stockID, note),
      ));
    }
    _changes.clear();
    _loading = false;
    notifyListeners();
  }

  @override
  void _onStockChangeSelect(TransferStockChanges stockChanges) {
    super._onStockChangeSelect(stockChanges);
    _sendQuntity.assign(stockChanges.sendQuntity);
    _afterSendQuntity.assign(stockChanges.afterSendQuntity);
    _focusedAt = Focuses.addQuntity;
  }

  @override
  void _onAction1Press() {
    if (_focusedAt == Focuses.itemNum) return;
    _updateSendQuntity("", 0, true);
  }

  void _updateSendQuntity(String digit, [int? val, bool negat = false]) {
    if (negat) {
      _sendQuntity.negate();
    } else if (val == null) {
      _sendQuntity.appendDigit(digit);
    } else {
      _sendQuntity.val = val;
    }
    _afterSendQuntity.val = _currentQuntity - _sendQuntity;
  }

  @override
  bool _onNumberPress(String number) {
    if (super._onNumberPress(number)) return true;
    _updateSendQuntity(number);
    return true;
  }

  @override
  void _addChanges() {
    final item = _itemCode.item;
    if (item == null) return;
    _changes.add(TransferStockChanges(
      itemId: item.id,
      sendQuntity: _sendQuntity.toFixedNumber(),
      currentQuntity: _currentQuntity,
      afterSendQuntity: _afterSendQuntity.toFixedNumber(),
    ));
    super._addChanges();
  }

  @override
  void _reset([Product? item]) {
    super._reset(item);
    _sendQuntity.val = 0;
    _afterSendQuntity.val = 0;
  }

  @override
  void _onAction2Press() {
    if (_itemCode.hasItem) {
      _processAction_2_3();
      _focusedAt = Focuses.addQuntity;
      _updateSendQuntity("", 0);
    }
  }

  @override
  void _onAction3Press() {
    _onAction2Press();
  }

  @override
  String get addedQuntity => _sendQuntity.text;

  @override
  String get setQuntity => _afterSendQuntity.text;

  @override
  void _onPeriodPress() {
    if (_focusedAt == Focuses.itemNum) return;
    _sendQuntity.periodPress();
    _afterSendQuntity.val = _currentQuntity + _sendQuntity;
  }
}

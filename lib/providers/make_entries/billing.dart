import 'package:flutter/material.dart';
import 'package:vdp/widgets/make_entry/display/billing.dart';
import 'package:vdp/widgets/make_entry/keybord/builder.dart';
import 'package:vdp/widgets/selectors/select_order.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/make_entries/custom/formate.dart';
import 'package:vdp/providers/make_entries/custom/item.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';

abstract class Billing extends Modal with ChangeNotifier {
  final String _stockID;
  final String _cashCounterID;

  var _focusedAt = Focuses.itemNum;
  var _inCash = true;
  final _fixedTotal = Number();
  final _total = Number();
  final _transfer = Number();
  final _quntity = Number();
  final _amount = Number();
  final _returnCash = Number();
  final ItemCode _itemCode = ItemCode();
  var _lastKeyPressed = KeybordKeyValue.enter;
  final List<Order> _orders = [];
  final _billingOnCloud = BillingOnCloud();
  var _loading = false;

  Billing(
    BuildContext context,
    this._stockID,
    this._cashCounterID,
  ) : super(context);

  Bill get bill;
  bool get loading => _loading;

  void update(ProductDoc items) {
    _itemCode.update(items);
    notifyListeners();
  }

  void _bill() async {
    _loading = true;
    notifyListeners();
    await handleCloudCall(_billingOnCloud.bill(_stockID, _cashCounterID, bill));
    _loading = false;
    notifyListeners();
  }

  void _onOrderSelect(Order order) {
    _orders.remove(order);
    _changeItemCodeTo("", order.item);
    _total.assign(_fixedTotal);
    _fixedTotal.val -= order.amount.val;
    _amount.assign(order.amount);
    _quntity.assign(order.quntity);
    _focusedAt = Focuses.quntity;
  }

  void openOrders() {
    if (_orders.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ShowOrders(
            orders: _orders,
            onOrderSelect: (order) {
              _onOrderSelect(order);
            },
            deleteOrder: (order) {
              _orders.remove(order);
              _fixedTotal.val -= order.amount.val;
              if (_focusedAt == Focuses.transfer) {
                _resetTransfer();
              } else {
                _resetOrder();
              }
            },
          );
        }),
      ).then((value) => notifyListeners());
    }
  }

  void openItemSelector() {
    if (focusedAt != Focuses.transfer) {
      _itemCode
          .openItemSelector(context, _resetOrder)
          .then((value) => _onItemSelect());
    }
  }

  void _onItemSelect() {
    notifyListeners();
  }

  void _changeQuntityTo(String digit, {int? val}) {
    if (val == null) {
      _quntity.appendDigit(digit);
    } else {
      _quntity.val = val;
    }
  }

  void _changeAmountTo(String digit, {int? val}) {
    if (val == null) {
      _amount.appendDigit(digit);
    } else {
      _amount.val = val;
    }
    _total.val = _fixedTotal + _amount;
  }

  void _changeItemCodeTo(String code, [Product? item]) {
    if (item != null) {
      _quntity.val = 0;
      _amount.val = 0;
      _total.assign(_fixedTotal);
      _itemCode.changeItemTo(item);
    } else {
      _itemCode.changeCodeTo(code);
    }
  }

  void _onPeriodPress() {
    switch (focusedAt) {
      case Focuses.quntity:
        _quntity.periodPress();
        break;
      case Focuses.price:
        _amount.periodPress();
        break;
      case Focuses.transfer:
        _transfer.periodPress();
        break;
      case Focuses.itemNum:
        break;
    }
  }

  void _changeTransferTo(String digit, {int? val}) {
    if (val == null) {
      _transfer.appendDigit(digit);
    } else {
      _transfer.val = val;
    }
    _returnCash.val = _transfer - _fixedTotal;
  }

  void _addOrder() {
    _fixedTotal.val += _amount.val;
    _resetOrder();
  }

  void _resetOrder([Product? item]) {
    _focusedAt = Focuses.itemNum;
    if (item == null) _itemCode.changeCodeTo("");
    _quntity.val = 0;
    _amount.val = 0;
    _total.assign(_fixedTotal);
  }

  void _resetTransfer() {
    if (_orders.isNotEmpty) {
      _focusedAt = Focuses.transfer;

      _transfer.val = 0;
      _returnCash.val = _transfer - _fixedTotal;
      _inCash = true;
    }
  }

  void _onClick(KeybordKeyValue action) {
    switch (action) {
      case KeybordKeyValue.enter:
        if (_focusedAt == Focuses.transfer && _orders.isNotEmpty) {
          _bill();
          _orders.clear();
          _fixedTotal.val = _total.val = 0;
          _resetOrder();
        } else {
          if (_itemCode.hasItem) {
            _addOrder();
          } else {
            _resetTransfer();
          }
        }
        break;
      case KeybordKeyValue.esc:
        if (_focusedAt == Focuses.transfer) {
          if (_transfer.isNotEmpty && _inCash) {
            _resetTransfer();
          } else {
            _resetOrder();
          }
        } else {
          if (_itemCode.isEmpty) {
            _orders.clear();
            _total.val = 0;
            _fixedTotal.val = 0;
          }
          _resetOrder();
        }
        break;
      case KeybordKeyValue.action1:
        _processAction_1_2();
        _focusedAt = Focuses.quntity;
        _changeQuntityTo("", val: 0);
        break;
      case KeybordKeyValue.action2:
        _processAction_1_2();
        _focusedAt = Focuses.price;
        _changeAmountTo("", val: 0);
        break;
      case KeybordKeyValue.action3:
        if (_focusedAt == Focuses.transfer) {
          if (_inCash) {
            _inCash = false;
            _transfer.assign(_total);
            _returnCash.val = 0;
          } else {
            _resetTransfer();
          }
        } else {
          _onClick(KeybordKeyValue.enter);
        }
        break;
      case KeybordKeyValue.period:
        _onPeriodPress();
        break;
      default:
        var number = action.num;
        if (number != null) {
          switch (_focusedAt) {
            case Focuses.itemNum:
              _changeItemCodeTo(_itemCode + number);
              break;
            case Focuses.price:
              _changeAmountTo(number);
              break;
            case Focuses.quntity:
              _changeQuntityTo(number);
              break;
            case Focuses.transfer:
              if (_inCash || _lastKeyPressed != KeybordKeyValue.action3) {
                _changeTransferTo(number);
              } else {
                _changeTransferTo(number);
              }
              break;
          }
        }
        break;
    }
  }

  void _processAction_1_2() {}

  void onClick(KeybordKeyValue action) {
    if (_loading) return;
    _onClick(action);
    _lastKeyPressed = action;
    notifyListeners();
  }

  String get rate;
  String get itemCode => _itemCode.code;

  Focuses get focusedAt => _focusedAt;

  String get name => _itemCode.name;
  String get quntity => _quntity.text;
  String get price => _amount.text;
  String get total => _total.text;

  bool get inCash => _inCash;
  String get returnCash => _returnCash.text;
  String get transfer => _transfer.text;
}

class RetailBilling extends Billing {
  var _useingRate2 = false;
  var _rate = "";

  RetailBilling(
    BuildContext context,
    String stockID,
    String cashCounterID,
  ) : super(context, stockID, cashCounterID);

  void _updateRate(Product item) {
    _rate = formate(_useingRate2 ? item.rate2 : item.rate1);
  }

  @override
  Bill get bill {
    return Bill(
      uid: "",
      billNum: "", // ? while sending request
      isWholeSell: false,
      inCash: _inCash,
      moneyGiven: FixedNumber.fromInt(_transfer.val),
      orders: [..._orders],
    );
  }

  @override
  void _onOrderSelect(Order order) {
    _useingRate2 = order.rate.val / 1000 == order.item.rate2;
    _updateRate(order.item);
    super._onOrderSelect(order);
  }

  @override
  void _onItemSelect() {
    final item = _itemCode.item;
    if (item == null) return;
    _changeQuntityTo("", val: 1000);
    _rate = formate(item.rate1);
    super._onItemSelect();
  }

  @override
  void _addOrder() {
    final item = _itemCode.item;
    if (item == null) return;
    if (_quntity.isEmpty || _amount.isEmpty) _changeQuntityTo("", val: 1000);
    _orders.add(Order(
      itemId: item.id,
      amount: _amount.toFixedNumber(),
      quntity: _quntity.toFixedNumber(),
      rate: FixedNumber.fromDouble(_useingRate2 ? item.rate2 : item.rate1),
    ));
    super._addOrder();
  }

  @override
  void _changeQuntityTo(String digit, {int? val}) {
    super._changeQuntityTo(digit, val: val);
    super._changeAmountTo("",
        val: _itemCode.item?.amountFor(
              quntity: _quntity.val,
              useingRate2: _useingRate2,
            ) ??
            0);
  }

  @override
  void _changeAmountTo(String digit, {int? val}) {
    super._changeAmountTo(digit, val: val);
    super._changeQuntityTo("",
        val: _itemCode.item?.quntityFor(
              amount: _amount.val,
              useingRate2: _useingRate2,
            ) ??
            0);
  }

  @override
  void _onPeriodPress() {
    if (focusedAt == Focuses.itemNum) {
      final item = _itemCode.item;
      if (item != null && item.rate2 != 0) {
        _useingRate2 = !_useingRate2;
        _updateRate(item);
        _changeQuntityTo("", val: 1000);
      }
    } else {
      super._onPeriodPress();
    }
  }

  @override
  void _resetOrder([Product? item]) {
    _rate = "";
    _useingRate2 = false;
    super._resetOrder(item);
  }

  @override
  void _changeItemCodeTo(String code, [Product? item]) {
    super._changeItemCodeTo(code.replaceFirst(".", ""), item);
    item ??= _itemCode.item;
    if (item != null) {
      _changeQuntityTo("", val: 1000);
      _rate = formate(item.rate1);
    } else {
      _changeQuntityTo("", val: 0);
      _rate = "";
    }
  }

  @override
  String get rate => _rate;

  @override
  String get itemCode => "$_itemCode${_useingRate2 ? "." : ""}";
}

class WholeSellBilling extends Billing {
  final _rate = Number();
  WholeSellBilling(
    BuildContext context,
    String stockID,
    String cashCounterID,
  ) : super(context, stockID, cashCounterID);

  @override
  void _onOrderSelect(Order order) {
    _rate.assign(order.rate);
    super._onOrderSelect(order);
  }

  @override
  Bill get bill {
    return Bill(
      uid: "",
      billNum: "", // ? while sending request
      isWholeSell: true,
      inCash: _inCash,
      moneyGiven: FixedNumber.fromInt(_transfer.val),
      orders: [..._orders],
    );
  }

  void _updateRate() {
    _rate.val = _amount / _quntity;
  }

  @override
  void _changeQuntityTo(String digit, {int? val}) {
    super._changeQuntityTo(digit, val: val);
    _updateRate();
  }

  @override
  void _changeAmountTo(String digit, {int? val}) {
    super._changeAmountTo(digit, val: val);
    _updateRate();
  }

  @override
  void _processAction_1_2() {
    final itemId = _itemCode.item?.id;
    if (itemId == null) return;
    final i = _orders.indexWhere((e) => e.itemId == itemId);
    if (i >= 0) {
      final order = _orders.removeAt(i);
      _fixedTotal.val -= order.amount.val;
      _total.assign(_fixedTotal);
    }
  }

  @override
  void _addOrder() {
    if (_quntity.isEmpty || _amount.isEmpty) return;
    _orders.add(Order(
      itemId: _itemCode.item?.id ?? "",
      amount: _amount.toFixedNumber(),
      quntity: _quntity.toFixedNumber(),
      rate: _rate.toFixedNumber(),
    ));
    super._addOrder();
  }

  @override
  void _resetOrder([Product? item]) {
    _rate.val = 0;
    super._resetOrder(item);
  }

  @override
  String get rate => _rate.text;
}

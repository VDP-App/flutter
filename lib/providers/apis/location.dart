import 'package:flutter/material.dart';
import 'package:vdp/documents/config.dart';
import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/utils/modal.dart';

class Location extends Modal with ChangeNotifier {
  ConfigDoc? _configDoc;
  final Claims claims;
  StockInfo? _stockInfo;
  CashCounterInfo? _cashCounterInfo;

  Location(BuildContext context, this.claims) : super(context);

  void update(ConfigDoc configDoc) {
    _configDoc = configDoc;
    _stockInfo ??= _configDoc?.getStockInfo(claims.defaultStockId);
    _cashCounterInfo ??=
        _stockInfo?.getCashCounterInfo(claims.defaultCashCouterId);
    notifyListeners();
  }

  bool get isEmpty => _stockInfo == null || _cashCounterInfo == null;

  String? get stockID => _stockInfo?.stockID;
  String? get stockName => _stockInfo?.name;

  String? get cashCounterID => _cashCounterInfo?.cashCounterID;
  String? get cashCounterName => _cashCounterInfo?.name;

  void selectStock() {
    if (!claims.hasAdminAuthorization) return;
    selectOne<StockInfo>(
      title: "Stock",
      currentlySelected: _stockInfo,
      modalListElement: _configDoc?.stocks ?? [],
      onSelect: (e) => _stockInfo = e,
    ).then((_) {
      _cashCounterInfo = _stockInfo?.defaultCashCounter();
      if (_stockInfo != null) notifyListeners();
    });
  }

  Future<void> selectCashCounter() async {
    if (!claims.hasManagerAuthorization) return;
    final stockInfo = _stockInfo;
    if (stockInfo == null) return selectStock();
    await selectOne<CashCounterInfo>(
      title: "Cash Counter",
      currentlySelected: _cashCounterInfo,
      modalListElement: stockInfo.cashCounters,
      onSelect: (e) => _cashCounterInfo = e,
    );
    notifyListeners();
  }
}

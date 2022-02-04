import 'package:flutter/material.dart';
import 'package:vdp/documents/config.dart';
import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/utils/modal.dart';

enum Roles { manager, accountent }

class EditClaims extends Modal {
  final Map<String, dynamic> _claims = {};
  final ConfigDoc configDoc;
  bool _isNull = true;
  EditClaims(BuildContext context, this.configDoc) : super(context);

  bool get isReady => !_isNull;
  bool get isNotReady => _isNull;

  int get role => asInt(_claims["r"]);
  String get stockID => asString(_claims["s"]);
  String get cashCounterID => asString(_claims["c"]);

  bool get isManager => _claims["r"] == 1;
  bool get isAccountent => _claims["r"] == 2;

  Roles? get hasRoleOf {
    if (_claims["r"] == 1) return Roles.manager;
    if (_claims["r"] == 2) return Roles.accountent;
    return null;
  }

  Future<StockInfo?> get _stockInfo async {
    StockInfo? _stockInfo;
    await selectOne<StockInfo>(
      title: "Select Stock",
      currentlySelected: null,
      modalListElement: configDoc.stocks,
      onSelect: (info) => _stockInfo = info,
    );
    return _stockInfo;
  }

  Future<void> onChange(Roles roles) async {
    _isNull = true;
    _claims.clear();
    if (roles == Roles.manager) {
      _claims["r"] = 1;
      final stockInfo = await _stockInfo;
      if (stockInfo == null) return;
      _claims["s"] = stockInfo.id;
    } else {
      _claims["r"] = 2;
      final stockInfo = await _stockInfo;
      if (stockInfo == null) return;
      _claims["s"] = stockInfo.id;
      final cashCounterID = await selectOne<CashCounterInfo>(
        title: "Select Stock",
        currentlySelected: null,
        modalListElement: stockInfo.cashCounters,
        onSelect: (_) {},
      );
      if (cashCounterID == null) return;
      _claims["c"] = cashCounterID;
    }
    _isNull = false;
  }
}

import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/utils/modal.dart';

class CashCounterInfo extends ModalListElement {
  const CashCounterInfo(
    String cashCounterID,
    String name,
  ) : super(name: name, id: cashCounterID);

  factory CashCounterInfo.fromJson({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return CashCounterInfo(id, asString(data["name"]));
  }
  String get cashCounterID => id;
}

class StockInfo extends ModalListElement {
  final List<CashCounterInfo> cashCounters;

  const StockInfo(
    this.cashCounters,
    String name,
    String stockID,
  ) : super(id: stockID, name: name);

  String get stockID => id;

  factory StockInfo.fromJson({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final List<CashCounterInfo> cashCounters = [];
    final counters = asMap(data["cashCounters"]);
    MapEntry element;
    for (element in counters.entries) {
      cashCounters.add(CashCounterInfo.fromJson(
        id: element.key,
        data: asMap(element.value),
      ));
    }
    return StockInfo(cashCounters, asString(data["name"]), id);
  }

  CashCounterInfo? defaultCashCounter() {
    if (cashCounters.length == 1) return cashCounters.first;
    return null;
  }

  CashCounterInfo? getCashCounterInfo(String? cashCounterID) {
    if (cashCounterID == null) return null;
    for (var c in cashCounters) {
      if (c.cashCounterID == cashCounterID) return c;
    }
    return null;
  }
}

class UserInfo {
  final String uid;
  final String email;
  final Claims claims;
  final String name;
  const UserInfo(this.claims, this.email, this.name, this.uid);

  factory UserInfo.fromJson({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return UserInfo(
      Claims(asMap(data["claim"])),
      asString(data["email"]),
      asString(data["name"]),
      uid,
    );
  }
}

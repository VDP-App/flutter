import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/documents/utils/parsing.dart';

class ConfigDoc {
  final List<StockInfo> stocks;
  final List<UserInfo> users;

  const ConfigDoc(this.stocks, this.users);
  factory ConfigDoc.fromJson(Map<String, dynamic> data) {
    final List<StockInfo> stocks = [];
    final List<UserInfo> users = [];
    MapEntry element;
    final stockMap = asMap(data["stocks"]);
    for (element in stockMap.entries) {
      stocks.add(StockInfo.fromJson(
        id: element.key,
        data: asMap(element.value),
      ));
    }
    final userMap = asMap(data["users"]);
    for (element in userMap.entries) {
      users.add(UserInfo.fromJson(
        uid: element.key,
        data: asMap(element.value),
      ));
    }
    return ConfigDoc(stocks, users);
  }

  StockInfo? getStockInfo(String? stockID) {
    if (stockID == null) return null;
    for (var s in stocks) {
      if (s.stockID == stockID) return s;
    }
    return null;
  }

  UserInfo? getUserInfo(String? uid) {
    if (uid == null) return null;
    for (var u in users) {
      if (u.uid == uid) return u;
    }
    return null;
  }
}

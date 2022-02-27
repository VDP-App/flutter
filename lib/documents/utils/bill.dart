import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/sorted_list.dart';
import 'package:vdp/providers/apis/custom/gst_bill.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class Bill extends CompareClass<Bill> {
  final bool isWholeSell;
  final bool inCash;
  final FixedNumber moneyGiven;
  final List<Order> orders;
  final String billNum;
  final String uid;
  const Bill({
    required this.isWholeSell,
    required this.inCash,
    required this.moneyGiven,
    required this.orders,
    required this.billNum,
    required this.uid,
  });

  factory Bill.fromMapEntry(MapEntry<String, dynamic> e) {
    return Bill.fromJson(asMap(parseJson(e.value)), e.key);
  }

  factory Bill.fromJson(Map<String, dynamic> data, String billNum) {
    return Bill(
      inCash: asBool(data["inC"]),
      isWholeSell: asBool(data["inWS"]),
      moneyGiven: FixedNumber.fromInt(asInt(data["mG"])),
      orders: asList(data["o"]).map((e) => Order.fromJson(asMap(e))).toList(),
      billNum: billNum,
      uid: asString(data["uid"]),
    );
  }

  FixedNumber get totalMoney {
    var i = 0;
    for (var order in orders) {
      i += order.amount.val;
    }
    return FixedNumber.fromInt(i);
  }

  Map<String, dynamic> toJson() {
    return {
      "isWS": isWholeSell, //? isWholeSell
      "inC": inCash, //? inCash
      "mG": moneyGiven.val, //? moneyGiven
      "o": orders.map((e) => e.toJson()).toList(), //? orders
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  GSTBill toGstBill() {
    return GSTBill(this);
  }

  @override
  Comparator compare(Bill e) {
    if (billNum == e.billNum) return Comparator.isEqual;
    if ((int.tryParse(billNum) ?? 0) > (int.tryParse(e.billNum) ?? 0)) {
      return Comparator.isGreater;
    }
    return Comparator.isLess;
  }
}

class Order {
  final String itemId;
  final FixedNumber quntity;
  final FixedNumber amount;
  final FixedNumber rate;

  Product get item {
    final a = productDoc?[itemId];
    if (a == null) throw "Something is wrong";
    return a;
  }

  const Order({
    required this.itemId,
    required this.amount,
    required this.quntity,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      "iId": itemId, //? itemId
      "q": quntity.val, //? quntity
      "a": amount.val, //? amount
      "r": rate.val, //? rate
    };
  }

  factory Order.fromJson(Map<String, dynamic> data) {
    return Order(
      itemId: asString(data["iId"]),
      amount: FixedNumber.fromInt(asInt(data["a"])),
      quntity: FixedNumber.fromInt(asInt(data["q"])),
      rate: FixedNumber.fromInt(asInt(data["r"])),
    );
  }

  @override
  String toString() {
    return {"quntity": quntity, "amount": amount, "rate": rate}.toString();
  }
}

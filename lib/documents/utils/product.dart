import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/random.dart';
import 'package:vdp/documents/utils/parsing.dart';

String? _parseCode(dynamic val) {
  if (val is! String) return null;
  return parseCode(val);
}

String parseCode(String val) {
  val = val.trim();
  return ("0000" + val).substring(val.length);
}

class Product {
  static final _ids = <String>{};

  final String? code;
  final String? collectionName;
  final String name;
  final String id;
  late final int _rate1;
  late final int _rate2;
  late final int _sgst;
  late final int _cgst;

  Product({
    required this.name,
    required int rate1,
    required int rate2,
    required int cgst,
    required int sgst,
    required this.id,
    this.code,
    this.collectionName,
  }) {
    _ids.add(id);
    _rate1 = rate1;
    _rate2 = rate2;
    _cgst = cgst;
    _sgst = sgst;
  }

  factory Product.fromInput({
    required String code,
    required String collectionName,
    required String name,
    required double rate1,
    required double rate2,
    required double cgst,
    required double sgst,
    String? id,
  }) {
    if (id == null) {
      while (Product._ids.contains(id)) {
        id = randomString;
      }
    }
    id ??= randomString;
    return Product(
      id: id,
      code: _parseCode(code),
      collectionName: collectionName,
      name: name,
      rate1: (rate1 * 1000).toInt(),
      rate2: (rate2 * 1000).toInt(),
      cgst: (cgst * 10).toInt(),
      sgst: (sgst * 10).toInt(),
    );
  }

  String get preview =>
      (collectionName ?? "--*--") + (rate2 > 0 ? "\t\t\t\t [$rs$rate2]" : "");

  bool get isDeleted => collectionName == null || code == null;

  bool isEqualTo(Product item) =>
      id == item.id &&
      code == item.code &&
      name == item.name &&
      collectionName == item.collectionName &&
      _rate1 == item._rate1 &&
      _rate2 == item._rate2 &&
      _sgst == item._sgst &&
      _cgst == item._cgst;

  factory Product.fromJSON(String id, Map<String, dynamic> raw) {
    return Product(
      id: id,
      code: _parseCode(raw["code"]),
      collectionName: asNullOrString(raw["collectionName"]),
      name: asString(raw["name"], "**"),
      rate1: asInt(raw["rate1"]),
      rate2: asInt(raw["rate2"]),
      cgst: asInt(raw["cgst"]),
      sgst: asInt(raw["sgst"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "collectionName": collectionName,
      "name": name,
      "rate1": _rate1,
      "rate2": _rate2,
      "cgst": _cgst,
      "sgst": _sgst,
    };
  }

  double get rate1 => _rate1 / 1000;
  double get rate2 => _rate2 / 1000;
  double get cgst => _cgst / 10;
  double get sgst => _sgst / 10;

  int quntityFor({required int amount, bool useingRate2 = false}) =>
      (amount * 1000) ~/ (useingRate2 ? _rate2 : _rate1);

  // ! 1 <=> 1000 => 500500 <=> Rs. 500.50
  int amountFor({required int quntity, bool useingRate2 = false}) =>
      quntity * (useingRate2 ? _rate2 : _rate1) ~/ 1000;

  @override
  String toString() {
    final map = toJson();
    map["id"] = id;
    return map.toString();
  }
}

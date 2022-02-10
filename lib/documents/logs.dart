import 'dart:convert';

import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class Log {
  final String _type;
  final Product product;
  final Product? oldProduct;
  final Map<String, FixedNumber>? remainingStock;
  final String createdBy;
  final String createdAt;

  const Log(
    this._type,
    this.createdAt,
    this.createdBy,
    this.product,
    this.oldProduct,
    this.remainingStock,
  );

  bool get isCreateItemLog => _type == "create";
  bool get isRemoveItemLog => _type == "remove";
  bool get isUpdateItemLog => _type == "update";

  bool get isImportant {
    final op = oldProduct;
    if (op == null) return true;
    if (op.rate1 != product.rate1 ||
        op.rate2 != product.rate2 ||
        op.sgst != product.sgst ||
        op.cgst != product.cgst) return true;
    return false;
  }

  String get preview {
    final op = oldProduct;
    if (op == null) return _type;
    var list = <String>[];
    if (op.rate1 != product.rate1) list.add("Rate1");
    if (op.rate2 != product.rate2) list.add("Rate2");
    if (op.cgst != product.cgst) list.add("Cgst");
    if (op.sgst != product.sgst) list.add("Sgst");
    if (op.code != product.code) list.add("Code Number");
    if (op.collectionName != product.collectionName) {
      list.add("Collection Name");
    }
    if (op.name != product.name) list.add("Item Name");
    return list.join(", ") + " have changed";
  }

  factory Log.fromJson(Map<String, dynamic> data) {
    return Log(
        asString(data["type"]),
        asString(data["createdAt"]),
        asString(data["createdBy"]),
        Product.fromJSON(asString(data["itemId"]), asMap(data["item"])),
        data["oldItem"] == null
            ? null
            : Product.fromJSON(
                asString(data["itemId"]), asMap(data["oldItem"])),
        data["remainingStock"] == null
            ? null
            : asMap(data["remainingStock"]).map((key, value) =>
                MapEntry(key, FixedNumber.fromInt(asInt(value)))));
  }
}

class LogDoc {
  final List<Log> logs;
  const LogDoc(this.logs);

  factory LogDoc.fromJson(Map<String, dynamic> data) {
    final logs = <Log>[];
    for (var log in asList(data["logs"])) {
      logs.insert(0, Log.fromJson(asMap(parseJson(log))));
    }
    return LogDoc(logs);
  }
}

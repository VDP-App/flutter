import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class StockChanges<T extends Changes> {
  final List<T> changes;
  final String stockID;
  final String? note;
  const StockChanges(this.changes, this.stockID, this.note);

  Map<String, dynamic> toJson() {
    return {
      "stockID": stockID,
      "changes": changes.map((e) => e.toJson()).toList(),
      "note": (note?.isEmpty ?? true) ? null : note,
    };
  }

  Map<String, dynamic> toJsonInTransferFormate(String sendTo) {
    return {
      "stockID": stockID,
      "changes": changes.map((e) => e.toJson()).toList(),
      "sendTostockID": sendTo,
      "type": "send",
    };
  }
}

class StockSettingChanges extends Changes {
  final bool isSetStock;
  final FixedNumber addedQuntity;
  final FixedNumber setQuntity;

  const StockSettingChanges({
    required String itemId,
    required FixedNumber currentQuntity,
    required this.isSetStock,
    required this.addedQuntity,
    required this.setQuntity,
  }) : super(itemId: itemId, currentQuntity: currentQuntity);

  @override
  Map<String, dynamic> toJson() {
    return {
      "iId": itemId,
      "type": isSetStock ? "set" : "increment",
      "val": isSetStock ? setQuntity.val : addedQuntity.val,
    };
  }
}

class TransferStockChanges extends Changes {
  final FixedNumber sendQuntity;
  final FixedNumber afterSendQuntity;

  const TransferStockChanges({
    required String itemId,
    required FixedNumber currentQuntity,
    required this.sendQuntity,
    required this.afterSendQuntity,
  }) : super(itemId: itemId, currentQuntity: currentQuntity);

  @override
  Map<String, dynamic> toJson() {
    return {
      "iId": itemId,
      // !
      "send": sendQuntity.val,
    };
  }
}

abstract class Changes {
  final String itemId;
  final FixedNumber currentQuntity;

  Product get item {
    final a = productDoc?[itemId];
    if (a == null) throw "Something is wrong";
    return a;
  }

  const Changes({required this.itemId, required this.currentQuntity});

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }
}

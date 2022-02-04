import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class ChangesInTransfer {
  final String itemId;
  final FixedNumber quntitySent;

  Product get item {
    final a = productDoc?[itemId];
    if (a == null) throw "Something is wrong";
    return a;
  }

  const ChangesInTransfer(this.itemId, this.quntitySent);

  factory ChangesInTransfer.fromJson(Map<String, dynamic> data) {
    return ChangesInTransfer(
      asString(data["iId"]),
      FixedNumber.fromInt(asInt(data["send"])),
    );
  }
}

class TransferNotifications {
  final List<ChangesInTransfer> stockChanges;
  final String transferFrom;
  final String senderUid;
  final String uniqueID;

  const TransferNotifications(
    this.stockChanges,
    this.transferFrom,
    this.senderUid,
    this.uniqueID,
  );
  factory TransferNotifications.fromJson(
    Map<String, dynamic> data,
    String uniqueID,
  ) {
    return TransferNotifications(
      asList(data["sC"])
          .map((e) => ChangesInTransfer.fromJson(asMap(e)))
          .toList(),
      asString(data["tF"]),
      asString(data["sUid"]),
      uniqueID,
    );
  }
  String get preview {
    if (stockChanges.isEmpty) return "--*--";
    final first = stockChanges.first;
    if (stockChanges.length == 1) {
      return "${first.item.name}: ${first.quntitySent.text}";
    }
    final second = stockChanges[1];
    return "${first.item.name}: ${first.quntitySent.text}, ${second.item.name}: ${second.quntitySent.text} ${stockChanges.length > 2 ? "..." : ""}";
  }
}

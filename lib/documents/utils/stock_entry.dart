import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/sorted_list.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class Entry extends CompareClass<Entry> {
  final List<StockChangesInEntry> stockChanges;
  final String? transferFrom;
  final String? transferTo;
  final String uid;
  final String? senderUid;
  final String entryNum;

  const Entry(
    this.senderUid,
    this.stockChanges,
    this.transferFrom,
    this.transferTo,
    this.uid,
    this.entryNum,
  );

  String get preview {
    if (stockChanges.isEmpty) return "--*--";
    final first = stockChanges.first;
    if (stockChanges.length == 1) {
      return "${first.item.name}: ${first.stockInc.text}";
    }
    final second = stockChanges[1];
    return "${first.item.name}: ${first.stockInc.text}, ${second.item.name}: ${second.stockInc.text} ${stockChanges.length > 2 ? "..." : ""}";
  }

  factory Entry.fromMapEntry(MapEntry<String, dynamic> e) {
    return Entry.fromJson(asMap(parseJson(e.value)), e.key);
  }

  factory Entry.fromJson(Map<String, dynamic> data, String entryNum) {
    return Entry(
      asNullOrString(data["sUid"]),
      asList(data["sC"]).map((e) => StockChangesInEntry.fromJson(e)).toList(),
      asNullOrString(data["tF"]),
      asNullOrString(data["tT"]),
      asString(data["uid"]),
      entryNum,
    );
  }

  @override
  Comparator compare(e) {
    if (entryNum == e.entryNum) return Comparator.isEqual;
    if ((int.tryParse(entryNum) ?? 0) > (int.tryParse(e.entryNum) ?? 0)) {
      return Comparator.isGreater;
    }
    return Comparator.isLess;
  }
}

enum StockSetType { increment, setStock }

class StockChangesInEntry {
  final String itemID;
  final FixedNumber stockAfter;
  final FixedNumber stockInc;
  final StockSetType? type;

  Product get item {
    final a = productDoc?[itemID];
    if (a == null) throw "Something is wrong";
    return a;
  }

  const StockChangesInEntry(
    this.itemID,
    this.stockAfter,
    this.stockInc,
    this.type,
  );

  FixedNumber get stockBefore {
    return FixedNumber.fromInt(stockAfter.val - stockInc.val);
  }

  factory StockChangesInEntry.fromJson(Map<String, dynamic> data) {
    final type = data["t"];
    return StockChangesInEntry(
      asString(data["iId"]),
      FixedNumber.fromInt(asInt(data["n"])),
      FixedNumber.fromInt(asInt(data["i"])),
      type == "set"
          ? StockSetType.setStock
          : type == "inc"
              ? StockSetType.increment
              : null,
    );
  }
}

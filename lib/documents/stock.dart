import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/documents/utils/transfer.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class StockDoc {
  final List<Entry> entry;
  final Map<String, FixedNumber> currentStock;
  final List<TransferNotifications> transferNotifications;

  const StockDoc(this.entry, this.currentStock, this.transferNotifications);

  factory StockDoc.fromJson(Map<String, dynamic> data) {
    return StockDoc(
      asList(data["entry"]).map((e) => Entry.fromJson(parseJson(e))).fold([],
          (previousValue, element) {
        previousValue.insert(0, element);
        return previousValue;
      }),
      asMap(data["currentStocks"]).map(
          (key, value) => MapEntry(key, FixedNumber.fromInt(asInt(value)))),
      asMap(data["transferNotifications"]).entries.map((e) {
        return TransferNotifications.fromJson(asMap(parseJson(e.value)), e.key);
      }).fold([], (previousValue, element) {
        previousValue.insert(0, element);
        return previousValue;
      }),
    );
  }
}

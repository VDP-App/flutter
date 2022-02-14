import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/report.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class SummeryDoc {
  final List<Bill> wholeSellBills;
  final List<Entry> entries;
  final Map<String, int> stockAtEnd;
  final Map<String, FixedProductReport> productReports;
  final FixedNumber totalOnlineIncome;
  final FixedNumber totalOfflineIncome;

  const SummeryDoc(
    this.wholeSellBills,
    this.entries,
    this.stockAtEnd,
    this.productReports,
    this.totalOfflineIncome,
    this.totalOnlineIncome,
  );

  factory SummeryDoc.fromJson(Map<String, dynamic> data) {
    final _wholeSell = parseJson(data["wholeSell"]);
    final _retail = parseJson(data["retail"]);
    final _entry = parseJson(data["entry"]);
    final _stockSnapShot = parseJson(data["stockSnapShot"]);
    final productReports = <String, ProductReport>{};
    final bills = <Bill>[];
    final entries = <Entry>[];
    dynamic e;
    Bill bill;
    Order order;
    Entry entry;
    StockChangesInEntry changes;
    getProductReport(String id) => productReports[id] ??= ProductReport();

    for (var e in asMap(_retail).entries) {
      final v = asMap(e.value);
      getProductReport(e.key).addRetail(asInt(v["q"]), asInt(v["r"]));
    }

    var i = 0;
    for (e in asList(_wholeSell)) {
      bill = Bill.fromJson(asMap(e), i.toString());
      bills.add(bill);
      for (order in bill.orders) {
        getProductReport(order.itemId).addWholeSell(order.quntity.val, i);
      }
      i++;
    }
    i = 0;
    for (e in asList(_entry)) {
      entry = Entry.fromJson(asMap(e), i.toString());
      entries.add(entry);
      if (entry.transferFrom != null) {
        for (changes in entry.stockChanges) {
          getProductReport(changes.itemID).addStockRecive(
            changes.stockInc.val,
            i,
          );
        }
      } else if (entry.transferTo != null) {
        for (changes in entry.stockChanges) {
          getProductReport(changes.itemID).addStockSend(
            changes.stockInc.val,
            i,
          );
        }
      } else {
        for (changes in entry.stockChanges) {
          getProductReport(changes.itemID).addStockChanges(
            changes.stockInc.val,
            i,
          );
        }
      }
      i++;
    }
    final _income = asMap(data["income"]);
    return SummeryDoc(
      bills,
      entries,
      asMap(_stockSnapShot).map(
        (key, value) => MapEntry(key, asInt(value)),
      ),
      productReports.map(
        (key, value) => MapEntry(
          key,
          FixedProductReport.fromProductReport(value, key),
        ),
      ),
      FixedNumber.fromInt(asInt(_income["offline"])),
      FixedNumber.fromInt(asInt(_income["online"])),
    );
  }
}

import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/report.dart';
import 'package:vdp/documents/utils/stock_entry.dart';

class SummeryDoc {
  final List<Bill> bills;
  final List<Entry> entries;
  final Map<String, int> stockAtEnd;
  final Map<String, FixedProductReport> productReports;
  final int totalOnlineIncome;
  final int totalOfflineIncome;

  const SummeryDoc(
    this.bills,
    this.entries,
    this.stockAtEnd,
    this.productReports,
    this.totalOfflineIncome,
    this.totalOnlineIncome,
  );

  factory SummeryDoc.fromJson(Map<String, dynamic> data) {
    final productReports = <String, ProductReport>{};
    final bills = <Bill>[];
    final entries = <Entry>[];
    int onlineIncome = 0;
    int offlineIncome = 0;
    var i = 0;
    int amount;
    dynamic e;
    Bill bill;
    Order order;
    Entry entry;
    StockChangesInEntry changes;
    getProductReport(String id) => productReports[id] ??= ProductReport();

    for (e in asList(data["entry"])) {
      amount = 0;
      bill = Bill.fromJson(asMap(e));
      bills.add(bill);
      if (bill.isWholeSell) {
        for (order in bill.orders) {
          amount += order.amount.val;
          getProductReport(order.itemId).addWholeSell(order.quntity.val, i);
        }
      } else {
        for (order in bill.orders) {
          amount += order.amount.val;
          getProductReport(order.itemId).addRetail(order.quntity.val);
        }
      }
      if (bill.inCash) {
        offlineIncome += amount;
      } else {
        onlineIncome += amount;
      }
      i++;
    }
    i = 0;
    for (e in asList(data["entry"])) {
      entry = Entry.fromJson(asMap(e));
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
    return SummeryDoc(
      bills,
      entries,
      asMap(data["currentStocks"]).map(
        (key, value) => MapEntry(key, asInt(value)),
      ),
      productReports.map(
        (key, value) => MapEntry(
          key,
          FixedProductReport.fromProductReport(value, key),
        ),
      ),
      offlineIncome,
      onlineIncome,
    );
  }
}

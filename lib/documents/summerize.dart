import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/summerize_report.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class SummerizeDoc {
  final List<SummeryOf<List<Bill>>> wholeSellBills;
  final List<SummeryOf<List<Entry>>> entries;
  final Map<String, FixedProductReport> productReports;
  final Map<String, TotalProductReport> totalProductReport;
  final FixedNumber totalRetailIncome;
  final FixedNumber totalWholeSellIncome;

  SummerizeDoc({
    required this.wholeSellBills,
    required this.entries,
    required this.productReports,
    required this.totalRetailIncome,
    required this.totalProductReport,
    required this.totalWholeSellIncome,
  });

  FixedProductReport? getReportOf(Product item) {
    return productReports[item.id];
  }

  TotalProductReport? getTotalReportOf(Product item) {
    return totalProductReport[item.id];
  }

  Entry? getEntryOf(SummerizeWith summerizeWith) {
    for (var _entries in entries) {
      if (_entries.date != summerizeWith.date) continue;
      return _entries.value[summerizeWith.index];
    }
    return null;
  }

  Bill? getBillOf(SummerizeWith summerizeWith) {
    for (var _bills in wholeSellBills) {
      if (_bills.date != summerizeWith.date) continue;
      return _bills.value[summerizeWith.index];
    }
    return null;
  }

  factory SummerizeDoc.fromJson(List<Map<String, dynamic>?> jsonList) {
    final wholeSellBills = <SummeryOf<List<Bill>>>[];
    final entries = <SummeryOf<List<Entry>>>[];
    final productReports = <String, ProductReport>{};
    var totalRetailIncome = 0;
    var totalWholeSellIncome = 0;
    var itemIDs = <String>{};
    for (var json in jsonList) {
      if (json == null) continue;
      final date = asString(json["date"]);
      productReports.forEach((key, value) {
        value.changeDate(date);
      });

      ProductReport getProductReport(String itemID) {
        itemIDs.add(itemID);
        return productReports[itemID] ??= ProductReport(itemID, date);
      }

      final _bills = <Bill>[];
      final _entries = <Entry>[];
      final _income = asMap(json["income"]);
      var _totalIncome = asInt(_income["offline"]) + asInt(_income["online"]);

      for (var e in asMap(parseJson(json["retail"])).entries) {
        for (var _v in asList(e.value)) {
          final v = asMap(_v);
          getProductReport(e.key).addRetail(asInt(v["q"]), asInt(v["r"]));
        }
      }
      var i = 0;
      for (var e in asList(parseJson(json["wholeSell"]))) {
        var bill = Bill.fromJson(asMap(e), i.toString());
        _bills.add(bill);
        for (var order in bill.orders) {
          _totalIncome -= order.amount.val;
          totalWholeSellIncome += order.amount.val;
          getProductReport(order.itemId)
              .addWholeSell(order.quntity, i, bill.note);
        }
        i++;
      }
      i = 0;
      for (var e in asList(parseJson(json["entry"]))) {
        var entry = Entry.fromJson(asMap(e), i.toString());
        _entries.add(entry);
        if (entry.transferFrom != null) {
          for (var changes in entry.stockChanges) {
            getProductReport(changes.itemID).addStockRecive(
              changes.stockInc,
              i,
            );
          }
        } else if (entry.transferTo != null) {
          for (var changes in entry.stockChanges) {
            getProductReport(changes.itemID).addStockSend(
              changes.stockInc,
              i,
            );
          }
        } else {
          for (var changes in entry.stockChanges) {
            getProductReport(changes.itemID).addStockChanges(
              changes,
              i,
              entry.note,
            );
          }
        }
        i++;
      }
      wholeSellBills.add(SummeryOf(date, _bills));
      entries.add(SummeryOf(date, _entries));
      totalRetailIncome += _totalIncome;
    }
    final _stockSnapShot = asMap(parseJson(jsonList.last?["stockSnapShot"]));
    final totalProductReport = <String, TotalProductReport>{};
    for (var itemID in itemIDs) {
      totalProductReport[itemID] = TotalProductReport(
        endStock: asInt(_stockSnapShot[itemID]),
        itemID: itemID,
      );
    }
    return SummerizeDoc(
      totalProductReport: totalProductReport,
      productReports: productReports.map((key, value) =>
          MapEntry(key, FixedProductReport.fromProductReport(value, key))),
      wholeSellBills: wholeSellBills,
      entries: entries,
      totalRetailIncome: FixedNumber.fromInt(totalRetailIncome),
      totalWholeSellIncome: FixedNumber.fromInt(totalWholeSellIncome),
    );
  }
}

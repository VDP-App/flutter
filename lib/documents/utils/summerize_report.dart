import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class SummeryOf<T> {
  final String? note;
  final T value;
  final String date;
  const SummeryOf(this.date, this.value, [this.note]);

  SummeryOf<N> imp<N>(N Function(T val) fn) => SummeryOf(date, fn(value), note);
}

class SummerizeWith<T> extends SummeryOf<T> {
  final int index;
  SummerizeWith(
    this.index,
    String date,
    T value, [
    String? note,
  ]) : super(date, value, note);
}

class ProductReport {
  static var totalRetail = <String, int>{};
  static var totalWholeSell = <String, int>{};
  static var totalStockInternalyAdded = <String, int>{};
  static var totalStockInternalyRemoved = <String, int>{};
  static var totalStockInternalErr = <String, int>{};
  static var totalStockSend = <String, int>{};
  static var totalStockRecive = <String, int>{};

  final retail = <int, int>{};
  final wholeSell = <SummerizeWith<FixedNumber>>[];
  final stockInternalyAdded = <SummerizeWith<StockChangesInEntry>>[];
  final stockInternalyRemoved = <SummerizeWith<StockChangesInEntry>>[];
  final stockInternalErr = <SummerizeWith<StockChangesInEntry>>[];
  final stockSend = <SummerizeWith<FixedNumber>>[];
  final stockRecive = <SummerizeWith<FixedNumber>>[];
  final String itemID;
  String date;
  ProductReport(this.itemID, this.date);

  void changeDate(String _date) {
    date = _date;
  }

  void addRetail(int q, int r) {
    totalRetail[itemID] = q + (totalRetail[itemID] ?? 0);
    retail[r] = q + (retail[q] ?? 0);
  }

  void addWholeSell(FixedNumber x, int i, String? note) {
    totalWholeSell[itemID] = x.val + (totalWholeSell[itemID] ?? 0);
    wholeSell.add(SummerizeWith(i, date, x, note));
  }

  void addStockChanges(StockChangesInEntry x, int i, String? note) {
    if (x.type == StockSetType.increment) {
      if (x.stockInc.val.isNegative) {
        totalStockInternalyRemoved[itemID] =
            x.stockInc.val + (totalStockInternalyRemoved[itemID] ?? 0);
        stockInternalyRemoved.add(SummerizeWith(i, date, x, note));
      } else {
        totalStockInternalyAdded[itemID] =
            x.stockInc.val + (totalStockInternalyAdded[itemID] ?? 0);
        stockInternalyAdded.add(SummerizeWith(i, date, x, note));
      }
    } else {
      totalStockInternalErr[itemID] =
          x.stockInc.val + (totalStockInternalErr[itemID] ?? 0);
      stockInternalErr.add(SummerizeWith(i, date, x, note));
    }
  }

  void addStockSend(FixedNumber x, int i) {
    totalStockSend[itemID] = x.val + (totalStockSend[itemID] ?? 0);
    stockSend.add(SummerizeWith(i, date, x));
  }

  void addStockRecive(FixedNumber x, int i) {
    totalStockRecive[itemID] = x.val + (totalStockRecive[itemID] ?? 0);
    stockRecive.add(SummerizeWith(i, date, x));
  }
}

class TotalProductReport {
  final FixedNumber startStock;
  final FixedNumber totalRetail;
  final FixedNumber totalWholeSell;
  final FixedNumber totalStockInternalyAdded;
  final FixedNumber totalStockInternalyRemoved;
  final FixedNumber totalStockInternalErr;
  final FixedNumber totalStockSend;
  final FixedNumber totalStockRecive;
  final FixedNumber endStock;
  final String itemID;
  TotalProductReport({required int endStock, required this.itemID})
      : startStock = FixedNumber.fromInt(
          endStock -
              (ProductReport.totalStockInternalyAdded[itemID] ?? 0) -
              (ProductReport.totalStockInternalyRemoved[itemID] ?? 0) -
              (ProductReport.totalStockInternalErr[itemID] ?? 0) -
              (ProductReport.totalStockSend[itemID] ?? 0) -
              (ProductReport.totalStockRecive[itemID] ?? 0) +
              (ProductReport.totalWholeSell[itemID] ?? 0) +
              (ProductReport.totalRetail[itemID] ?? 0),
        ),
        totalRetail =
            FixedNumber.fromInt((ProductReport.totalRetail[itemID] ?? 0)),
        totalWholeSell =
            FixedNumber.fromInt((ProductReport.totalWholeSell[itemID] ?? 0)),
        totalStockInternalyAdded = FixedNumber.fromInt(
            (ProductReport.totalStockInternalyAdded[itemID] ?? 0)),
        totalStockInternalyRemoved = FixedNumber.fromInt(
            (ProductReport.totalStockInternalyRemoved[itemID] ?? 0)),
        totalStockInternalErr = FixedNumber.fromInt(
            (ProductReport.totalStockInternalErr[itemID] ?? 0)),
        totalStockSend =
            FixedNumber.fromInt((ProductReport.totalStockSend[itemID] ?? 0)),
        totalStockRecive =
            FixedNumber.fromInt((ProductReport.totalStockRecive[itemID] ?? 0)),
        endStock = FixedNumber.fromInt(endStock);
}

class FixedProductReport {
  final Map<FixedNumber, FixedNumber> retail;
  final List<SummerizeWith<FixedNumber>> wholeSell;
  final List<SummerizeWith<StockChangesInEntry>> stockInternalyAdded;
  final List<SummerizeWith<StockChangesInEntry>> stockInternalyRemoved;
  final List<SummerizeWith<StockChangesInEntry>> stockInternalErr;
  final List<SummerizeWith<FixedNumber>> stockSend;
  final List<SummerizeWith<FixedNumber>> stockRecive;
  final String itemId;
  const FixedProductReport({
    required this.retail,
    required this.stockInternalyAdded,
    required this.stockInternalErr,
    required this.stockInternalyRemoved,
    required this.stockRecive,
    required this.stockSend,
    required this.wholeSell,
    required this.itemId,
  });

  Product get item {
    final a = productDoc?[itemId];
    if (a == null) throw "Something is wrong";
    return a;
  }

  factory FixedProductReport.fromProductReport(
    ProductReport productReports,
    String itemId,
  ) {
    return FixedProductReport(
      retail: productReports.retail.map(
        (key, value) =>
            MapEntry(FixedNumber.fromInt(key), FixedNumber.fromInt(value)),
      ),
      stockInternalyAdded: productReports.stockInternalyAdded,
      stockInternalErr: productReports.stockInternalErr,
      stockInternalyRemoved: productReports.stockInternalyRemoved,
      stockRecive: productReports.stockRecive,
      stockSend: productReports.stockSend,
      wholeSell: productReports.wholeSell,
      itemId: itemId,
    );
  }
}

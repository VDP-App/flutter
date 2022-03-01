import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class WholeSellProductReport extends FixedNumber {
  final String? note;
  WholeSellProductReport(FixedNumber x, this.note) : super.copy(x);
}

class StockChangesProductReport extends StockChangesInEntry {
  final String? note;
  StockChangesProductReport(StockChangesInEntry x, this.note) : super.copy(x);
}

class ProductReport {
  var totalRetail = 0;
  var totalWholeSell = 0;
  var totalStockChanges = 0;
  var totalStockSend = 0;
  var totalStockRecive = 0;
  final retail = <int, int>{};
  final wholeSell = <int, WholeSellProductReport>{};
  final stockChanges = <int, StockChangesProductReport>{};
  final stockSend = <int, FixedNumber>{};
  final stockRecive = <int, FixedNumber>{};
  ProductReport();

  void addRetail(int q, int r) {
    totalRetail += q;
    retail[r] = q + (retail[q] ?? 0);
  }

  void addWholeSell(FixedNumber x, int i, String? note) {
    totalWholeSell += x.val;
    wholeSell[i] = WholeSellProductReport(x, note);
  }

  void addStockChanges(StockChangesInEntry x, int i, String? note) {
    totalStockChanges += x.stockInc.val;
    stockChanges[i] = StockChangesProductReport(x, note);
  }

  void addStockSend(FixedNumber x, int i) {
    totalStockSend += x.val;
    stockSend[i] = x;
  }

  void addStockRecive(FixedNumber x, int i) {
    totalStockRecive += x.val;
    stockRecive[i] = x;
  }
}

class FixedProductReport {
  final FixedNumber totalRetail;
  final FixedNumber totalWholeSell;
  final FixedNumber totalStockChanges;
  final FixedNumber totalStockSend;
  final FixedNumber totalStockRecive;
  final Map<FixedNumber, FixedNumber> retail;
  final Map<int, WholeSellProductReport> wholeSell;
  final Map<int, StockChangesProductReport> stockChanges;
  final Map<int, FixedNumber> stockSend;
  final Map<int, FixedNumber> stockRecive;
  final String itemId;
  const FixedProductReport({
    required this.retail,
    required this.stockChanges,
    required this.stockRecive,
    required this.stockSend,
    required this.totalRetail,
    required this.totalStockChanges,
    required this.totalStockRecive,
    required this.totalStockSend,
    required this.totalWholeSell,
    required this.wholeSell,
    required this.itemId,
  });

  int get netQuntityChange =>
      totalStockChanges.val +
      totalStockSend.val +
      totalStockRecive.val -
      totalWholeSell.val -
      totalRetail.val;

  Product get item {
    final a = productDoc?[itemId];
    if (a == null) throw "Something is wrong";
    return a;
  }

  factory FixedProductReport.fromProductReport(
    ProductReport productReport,
    String itemId,
  ) {
    return FixedProductReport(
      retail: productReport.retail.map(
        (key, value) =>
            MapEntry(FixedNumber.fromInt(key), FixedNumber.fromInt(value)),
      ),
      stockChanges: productReport.stockChanges.map(
        (key, value) => MapEntry(key, value),
      ),
      stockRecive: productReport.stockRecive,
      stockSend: productReport.stockSend,
      totalRetail: FixedNumber.fromInt(productReport.totalRetail),
      totalStockChanges: FixedNumber.fromInt(productReport.totalStockChanges),
      totalStockRecive: FixedNumber.fromInt(productReport.totalStockRecive),
      totalStockSend: FixedNumber.fromInt(productReport.totalStockSend),
      totalWholeSell: FixedNumber.fromInt(productReport.totalWholeSell),
      wholeSell: productReport.wholeSell,
      itemId: itemId,
    );
  }
}

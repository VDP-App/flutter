import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class ProductReport {
  var totalRetail = 0;
  var totalWholeSell = 0;
  var totalStockChanges = 0;
  var totalStockSend = 0;
  var totalStockRecive = 0;
  final retail = <int, int>{};
  final wholeSell = <int, int>{};
  final stockChanges = <int, int>{};
  final stockSend = <int, int>{};
  final stockRecive = <int, int>{};
  ProductReport();

  void addRetail(int q, int r) {
    totalRetail += q;
    retail[r] = q + (retail[q] ?? 0);
  }

  void addWholeSell(int x, int i) {
    totalWholeSell += x;
    wholeSell[i] = x + (wholeSell[i] ?? 0);
  }

  void addStockChanges(int x, int i) {
    totalStockChanges += x;
    stockChanges[i] = x;
  }

  void addStockSend(int x, int i) {
    totalStockSend += x;
    stockSend[i] = x;
  }

  void addStockRecive(int x, int i) {
    totalStockRecive += x;
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
  final Map<int, FixedNumber> wholeSell;
  final Map<int, FixedNumber> stockChanges;
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
        (key, value) => MapEntry(key, FixedNumber.fromInt(value)),
      ),
      stockRecive: productReport.stockRecive.map(
        (key, value) => MapEntry(key, FixedNumber.fromInt(value)),
      ),
      stockSend: productReport.stockSend.map(
        (key, value) => MapEntry(key, FixedNumber.fromInt(value)),
      ),
      totalRetail: FixedNumber.fromInt(productReport.totalRetail),
      totalStockChanges: FixedNumber.fromInt(productReport.totalStockChanges),
      totalStockRecive: FixedNumber.fromInt(productReport.totalStockRecive),
      totalStockSend: FixedNumber.fromInt(productReport.totalStockSend),
      totalWholeSell: FixedNumber.fromInt(productReport.totalWholeSell),
      wholeSell: productReport.wholeSell.map(
        (key, value) => MapEntry(key, FixedNumber.fromInt(value)),
      ),
      itemId: itemId,
    );
  }
}

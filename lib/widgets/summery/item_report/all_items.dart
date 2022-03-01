import 'package:flutter/material.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/summery.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/report.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/widgets/summery/display_table.dart';
import 'package:vdp/widgets/summery/item_report/item_report.dart';

class AllItems extends StatelessWidget {
  const AllItems({
    Key? key,
    required this.productDoc,
    required this.summeryDoc,
  }) : super(key: key);
  final ProductDoc productDoc;
  final SummeryDoc summeryDoc;

  Map<String, FixedProductReport> get productReports =>
      summeryDoc.productReports;

  @override
  Widget build(BuildContext context) {
    final allProducts = productDoc.allProducts;
    return TablePage(
      pageTitle: "Items Table",
      titleNames: const [
        "Name",
        "Start",
        "Retail",
        "Whole",
        "Int.",
        "Send",
        "Recive",
        "End",
      ],
      getID: (i) => TablePageID(allProducts.elementAt(i).name),
      getRow: (i) {
        final item = allProducts.elementAt(i);
        final itemReport = productReports[item.id];
        final endStock =
            summeryDoc.stockAtEnd[item.id] ?? FixedNumber.fromInt(0);
        final startStock = FixedNumber.fromInt(
            endStock.val - (itemReport?.netQuntityChange ?? 0));
        return [
          TablePageCell(startStock.text, color: Colors.red),
          TablePageCell(itemReport?.totalRetail.negateText ?? "--"),
          TablePageCell(itemReport?.totalWholeSell.negateText ?? "--"),
          TablePageCell(itemReport?.totalStockChanges.text ?? "--"),
          TablePageCell(itemReport?.totalStockSend.text ?? "--"),
          TablePageCell(itemReport?.totalStockRecive.text ?? "--"),
          TablePageCell(endStock.text, color: Colors.red),
        ];
      },
      length: allProducts.length,
      rowCellWidth: [
        width5char,
        width5char,
        width5char,
        width5char,
        width5char,
        width5char,
        width5char
      ],
      onTapRow: (i) => openItemReport(
        context,
        allProducts.elementAt(i),
        summeryDoc,
      ),
    );
  }
}

void openItemReport(
  BuildContext context,
  Product item,
  SummeryDoc summeryDoc,
) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: appBarTitle("Item Report")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FullItemReport(product: item, summeryDoc: summeryDoc),
        ),
      );
    }),
  );
}

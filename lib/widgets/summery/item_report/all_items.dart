import 'package:flutter/material.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/summerize.dart';
import 'package:vdp/documents/utils/summerize_report.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/widgets/summery/display_table.dart';
import 'package:vdp/widgets/summery/item_report/item_report.dart';

class AllItems extends StatelessWidget {
  const AllItems(
      {Key? key, required this.productDoc, required this.summerizeDoc})
      : super(key: key);
  final ProductDoc productDoc;
  final SummerizeDoc summerizeDoc;

  Map<String, FixedProductReport> get productReports =>
      summerizeDoc.productReports;

  @override
  Widget build(BuildContext context) {
    final allProducts = productDoc.allProducts;
    return TablePage(
      id: "1",
      pageTitle: "Items Table",
      titleNames: const [
        "Name",
        "Start",
        "Recive",
        "+Int.",
        "-Int.",
        "Retail",
        "Whole",
        "Send",
        "Err.",
        "End",
      ],
      getID: (i) => TablePageID(allProducts.elementAt(i).name),
      getRow: (i) {
        final item = allProducts.elementAt(i);
        final productOverview = summerizeDoc.getTotalReportOf(item);
        return [
          TablePageCell(productOverview?.startStock.text ?? "--",
              color: Colors.red),
          TablePageCell(productOverview?.totalStockRecive.text ?? "--"),
          TablePageCell(productOverview?.totalStockInternalyAdded.text ?? "--"),
          TablePageCell(
              productOverview?.totalStockInternalyRemoved.text ?? "--"),
          TablePageCell(productOverview?.totalRetail.negateText ?? "--"),
          TablePageCell(productOverview?.totalWholeSell.negateText ?? "--"),
          TablePageCell(productOverview?.totalStockSend.text ?? "--"),
          TablePageCell(productOverview?.totalStockInternalErr.text ?? "--"),
          TablePageCell(productOverview?.endStock.text ?? "--",
              color: Colors.red),
        ];
      },
      length: allProducts.length,
      onTapRow: (i) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Scaffold(
              appBar: AppBar(title: appBarTitle("Item Report")),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FullItemReport(
                  product: allProducts.elementAt(i),
                  summerizeDoc: summerizeDoc,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

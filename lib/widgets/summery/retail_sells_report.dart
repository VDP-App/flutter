import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/report.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/summery/card_button.dart';

class RetailSellsReport extends StatelessWidget {
  const RetailSellsReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summery = Provider.of<Summery>(context);
    final products = Provider.of<Products>(context);
    final productDoc = products.doc;
    final summeryDoc = summery.doc;
    final productReports = summeryDoc?.productReports;
    final totalSold = summeryDoc?.totalRetailIncome;
    return CardButton(
      iconData: Icons.store,
      title: "Retail Sells",
      subtitle: "Net Income $rs $totalSold",
      color: summeryDoc == null || totalSold?.val == 0
          ? Colors.grey
          : Colors.indigoAccent,
      onTap: productReports == null || productDoc == null || totalSold?.val == 0
          ? () {}
          : () => openRetailSellsReport(context, productReports, productDoc),
      isLoading: summery.isEmpty == null || productDoc == null,
    );
  }
}

void openRetailSellsReport(
  BuildContext context,
  Map<String, FixedProductReport> productReports,
  ProductDoc productDoc,
) {
  void addRows(List<List<String>> _rows, Iterable<Product> products) {
    for (var item in products) {
      final retails = productReports[item.id]?.retail;
      if (retails == null) continue;
      for (var entry in retails.entries) {
        _rows.add([
          item.name,
          rs + entry.key.text,
          entry.value.text,
          rs + FixedNumber.fromInt(entry.key * entry.value).text,
        ]);
      }
    }
  }

  Navigator.push(context, MaterialPageRoute(builder: (context) {
    final rows = <List<String>>[];
    final products = productDoc.getItemInCollection(allCollectionNameKey);
    if (products != null) addRows(rows, products);
    final rowsDeleted = <List<String>>[];
    addRows(rowsDeleted, productDoc.deleatedItems);
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(isTablet ? "Retail Sells Report" : "Retail Rep."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: rows.isEmpty
            ? const NoData(text: "No Retail Sells")
            : ListView(
                children: [
                  const SizedBox(height: 20),
                  DisplayTable.fromString(
                    titleNames: const ["Name", "R", "Q", "A"],
                    data2D: rows,
                  ),
                  const SizedBox(height: 20),
                  if (rowsDeleted.isNotEmpty) ...[
                    const H1("Deleted Item"),
                    const SizedBox(height: 20),
                    DisplayTable.fromString(
                      titleNames: const ["Name", "R", "Q", "A"],
                      data2D: rowsDeleted,
                      colorRow: Iterable.generate(
                          rowsDeleted.length, (_) => Colors.red),
                    ),
                  ]
                ],
              ),
      ),
    );
  }));
}

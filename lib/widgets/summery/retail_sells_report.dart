import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/summery.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/display_table.dart';

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
    final totalSold = summeryDoc?.totalRetailIncome;
    return CardButton(
      iconData: Icons.store,
      title: "Retail Sells",
      subtitle: "Net Income $rs $totalSold",
      color: summeryDoc == null || totalSold?.val == 0
          ? Colors.grey
          : Colors.indigoAccent,
      onTap: summeryDoc == null || productDoc == null || totalSold?.val == 0
          ? () {}
          : () => openRetailSellsReport(context, summeryDoc, productDoc),
      isLoading: summery.isEmpty == null || productDoc == null,
    );
  }
}

void openRetailSellsReport(
  BuildContext context,
  SummeryDoc summeryDoc,
  ProductDoc productDoc,
) {
  final productReports = summeryDoc.productReports;
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
    return TablePage.fromString(
      pageTitle: isTablet ? "Retail Sells Report" : "Retail Rep.",
      titleNames: const ["Name", "R", "Q", "A"],
      data2D: Iterable.generate(
        rows.length + (rowsDeleted.isEmpty ? 0 : (2 + rowsDeleted.length)) + 2,
        (i) {
          if (i < rows.length) return rows[i];
          if (i == rows.length) return [" ", " ", " ", " "];
          if (rowsDeleted.isNotEmpty) {
            if (i == rows.length + 1) return ["DELETED ITEM", " ", " ", " "];
            i -= rows.length + 2;
            if (i < rowsDeleted.length) return rowsDeleted[i];
          }
          if (i == rows.length) return [" ", " ", " ", " "];
          return [
            "NET INCOME",
            " ",
            " ",
            rs + summeryDoc.totalRetailIncome.text
          ];
        },
      ),
      idWidth: idWidth,
      rowCellWidth: [width4char, width5char, width8char],
      colorRow: Iterable.generate(
        rows.length + (rowsDeleted.isEmpty ? 0 : (2 + rowsDeleted.length)) + 2,
        (i) {
          if (i < rows.length) return null;
          if (i == rows.length) return null;
          if (rowsDeleted.isNotEmpty) {
            if (i == rows.length + 1) return Colors.red;
            i -= rows.length + 2;
            if (i < rowsDeleted.length) return Colors.redAccent;
          }
          if (i == rows.length) return null;
          return Colors.deepPurpleAccent;
        },
      ),
    );
  }));
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/summerize.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/summerize.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/display_table.dart';

class CancledBillReport extends StatelessWidget {
  const CancledBillReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summerize = Provider.of<Summerize>(context);
    final products = Provider.of<Products>(context);
    final productDoc = products.doc;
    final summerizeDoc = summerize.doc;
    if (summerizeDoc == null || productDoc == null) return const SizedBox();
    final totalCancled = summerizeDoc.totalCancledIncome;
    return CardButton(
      iconData: Icons.cancel,
      title: "Cancled Sells",
      subtitle: "Net Income $rs $totalCancled",
      color: totalCancled.val == 0 ? Colors.grey : Colors.redAccent,
      onTap: totalCancled.val == 0
          ? () {}
          : () => openCancledSellsReport(
                context,
                summerizeDoc,
                productDoc,
              ),
    );
  }
}

void openCancledSellsReport(
  BuildContext context,
  SummerizeDoc summerizeDoc,
  ProductDoc productDoc,
) {
  final productReports = summerizeDoc.productReports;
  void addRows(List<List<String>> _rows, Iterable<Product> products) {
    for (var item in products) {
      final cancled = productReports[item.id]?.cancled;
      if (cancled == null) continue;
      for (var entry in cancled.entries) {
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
      id: "2",
      pageTitle: isTablet ? "Cancled Sells Report" : "Cancled Rep.",
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
            "NET AMOUNT",
            " ",
            " ",
            rs + summerizeDoc.totalCancledIncome.text
          ];
        },
      ),
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

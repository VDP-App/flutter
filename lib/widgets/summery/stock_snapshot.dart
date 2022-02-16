import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/summery/card_button.dart';

class StockSnapshot extends StatelessWidget {
  const StockSnapshot({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summery = Provider.of<Summery>(context);
    final products = Provider.of<Products>(context);
    final productDoc = products.doc;
    final stockAtEnd = summery.doc?.stockAtEnd;
    return CardButton(
      iconData: Icons.report,
      title: "Stock At End",
      subtitle: "Stock Remaining at End of the day",
      color: stockAtEnd == null ? Colors.grey : Colors.blueAccent,
      onTap: stockAtEnd == null || productDoc == null
          ? () {}
          : () => displayStockSnapshot(
                context,
                stockAtEnd,
                productDoc,
                summery.dateInString,
              ),
      isLoading: summery.isEmpty == null || productDoc == null,
    );
  }
}

void displayStockSnapshot(
  BuildContext context,
  Map<String, FixedNumber> stockSnapshot,
  ProductDoc productDoc, [
  String? date,
]) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    final deletedRow = <List<String>>[];
    for (var item in productDoc.deleatedItems) {
      final stock = stockSnapshot[item.id];
      if (stock != null) deletedRow.add([item.name, stock.text]);
    }
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle("${date ?? "Current"} Stock Report Table"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            DisplayTable.fromString(
              titleNames: const ["Name", "Q"],
              data2D: productDoc.allProducts.map((item) {
                return [item.name, stockSnapshot[item.id]?.text ?? "--"];
              }),
            ),
            const SizedBox(height: 20),
            if (deletedRow.isNotEmpty) ...[
              const H1("Deleted Item"),
              const SizedBox(height: 20),
              DisplayTable.fromString(
                titleNames: const ["Name", "Q"],
                data2D: deletedRow,
                colorRow: Iterable.generate(
                  deletedRow.length,
                  (_) => Colors.redAccent,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }));
}

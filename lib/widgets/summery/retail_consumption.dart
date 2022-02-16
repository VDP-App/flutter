import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/cash_counter.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/cash_counter.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/summery/card_button.dart';

class RetailConsumption extends StatelessWidget {
  const RetailConsumption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productsDoc = products.doc;
    final cashCounter = Provider.of<CashCounter>(context);
    final cashCounterDoc = cashCounter.doc;
    return CardButton(
      title: "Consumed",
      color: Colors.redAccent,
      onTap: () =>
          openRetailConsumptionTable(context, cashCounterDoc!, productsDoc!),
      isInfo: true,
      isLoading: cashCounterDoc == null || productsDoc == null,
    );
  }
}

void openRetailConsumptionTable(
  BuildContext context,
  CashCounterDoc cashCounterDoc,
  ProductDoc productDoc,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    final deletedRow = <List<String>>[];
    for (var item in productDoc.deleatedItems) {
      final stock = cashCounterDoc.stockConsumed[item.id];
      if (stock != null) deletedRow.add([item.name, stock.text]);
    }
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(isTablet ? "Retail Consumption Table" : "Retail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            DisplayTable.fromString(
              titleNames: const ["Name", "Q"],
              data2D: productDoc.allProducts.map((item) {
                return [
                  item.name,
                  cashCounterDoc.stockConsumed[item.id]?.text ?? "--"
                ];
              }),
            ),
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

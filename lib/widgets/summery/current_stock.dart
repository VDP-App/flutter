import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/widgets/summery/display_table.dart';

class CurrentStock extends StatelessWidget {
  const CurrentStock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productsDoc = products.doc;
    final stock = Provider.of<Stock>(context);
    final location = Provider.of<Location>(context);
    final currentStock = stock.doc?.currentStock;
    final stockID = location.stockID;
    return CardButton(
      iconData: Icons.inventory,
      title: "Current",
      subtitle: "Stock In Inventory",
      color: Colors.blueAccent,
      onTap: () => displayStockSnapshot(
        context,
        currentStock!,
        productsDoc!,
        stockID!,
      ),
      isLoading: currentStock == null || productsDoc == null,
    );
  }
}

const productionID = "2DipUoHYdd";
const sellesID = "9CMFCTLk7v";

void displayStockSnapshot(
  BuildContext context,
  Map<String, FixedNumber> stockSnapshot,
  ProductDoc productDoc,
  String stockID,
) {
  if (stockID != productionID && stockID != sellesID) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      final allProducts = productDoc.allProducts;
      return TablePage(
        id: "CurrentStock",
        pageTitle: "Current Stock Report Table",
        titleNames: const ["Item", "Stock Unit"],
        getID: (i) => TablePageID(allProducts.elementAt(i).name),
        getRow: (i) => [
          TablePageCell(stockSnapshot[allProducts.elementAt(i).id]?.text ?? "0")
        ],
        length: allProducts.length,
      );
    }));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      final allProducts = productDoc.allProducts;
      return FutureBuilder<Map<String, FixedNumber>?>(
        future: getDoc(
          docPath:
              "stocks/${stockID == productionID ? sellesID : productionID}",
          converter: _getSnapshot,
        ),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return TablePage(
              key: const Key("unresolve"),
              id: "CurrentStock",
              pageTitle: snapshot.hasError ? "Error Occured" : "Loading...",
              titleNames: [
                "Item",
                stockID == productionID ? "Prod." : "Sell.",
              ],
              getID: (i) => TablePageID(allProducts.elementAt(i).name),
              getRow: (i) => [
                TablePageCell(
                  stockSnapshot[allProducts.elementAt(i).id]?.text ?? "0",
                ),
              ],
              length: allProducts.length,
            );
          }
          final prodData = productionID == stockID ? stockSnapshot : data;
          final sellData = sellesID == stockID ? stockSnapshot : data;
          final zero = FixedNumber.fromInt(0);
          return TablePage(
            key: const Key("resolve"),
            id: "CurrentStock",
            pageTitle: "Prod & Sell",
            titleNames: const ["Item", "Prod.", "Sell.", "Total"],
            getID: (i) => TablePageID(allProducts.elementAt(i).name),
            getRow: (i) {
              final itemID = allProducts.elementAt(i).id;
              final pStock = prodData[itemID] ?? zero;
              final sStock = sellData[itemID] ?? zero;
              final tStock = FixedNumber.fromInt(pStock + sStock);
              return [
                TablePageCell(pStock.text),
                TablePageCell(sStock.text),
                TablePageCell(tStock.text),
              ];
            },
            length: allProducts.length,
          );
        },
      );
    }));
  }
}

Map<String, FixedNumber> _getSnapshot(Map<String, dynamic> data) {
  final res = <String, FixedNumber>{};
  for (var item in asMap(data["currentStocks"]).entries) {
    res[item.key] = FixedNumber.fromInt(asInt(item.value));
  }
  return res;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/stock_snapshot.dart';

class CurrentStock extends StatelessWidget {
  const CurrentStock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productsDoc = products.doc;
    final stock = Provider.of<Stock>(context);
    final currentStock = stock.doc?.currentStock;
    return CardButton(
      title: "Current",
      color: Colors.blueAccent,
      onTap: () => displayStockSnapshot(context, currentStock!, productsDoc!),
      isInfo: true,
      isLoading: currentStock == null || productsDoc == null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/summerize.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/item_report/all_items.dart';

class ItemSummery extends StatelessWidget {
  const ItemSummery({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summerize = Provider.of<Summerize>(context);
    final products = Provider.of<Products>(context);
    final productDoc = products.doc;
    final summerizeDoc = summerize.doc;
    if (summerizeDoc == null || productDoc == null) return const SizedBox();
    return CardButton(
      iconData: Icons.view_in_ar_rounded,
      title: "Item Report",
      subtitle: "Overview of Each Item",
      color: Colors.greenAccent,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AllItems(productDoc: productDoc, summerizeDoc: summerizeDoc);
        }));
      },
    );
  }
}

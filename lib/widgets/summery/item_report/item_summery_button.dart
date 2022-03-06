import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/summery.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/item_report/all_items.dart';

class ItemSummery extends StatelessWidget {
  const ItemSummery({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summery = Provider.of<Summery>(context);
    final products = Provider.of<Products>(context);
    final productDoc = products.doc;
    final summeryDoc = summery.doc;
    return CardButton(
      iconData: Icons.view_in_ar_rounded,
      title: "Item Report",
      subtitle: "Overview of Each Item",
      color: summeryDoc == null ? Colors.grey : Colors.greenAccent,
      onTap: summeryDoc == null || productDoc == null
          ? () {}
          : () => openItemSummeryReport(
              context, productDoc, summeryDoc, summery.dateInShort),
      isLoading: summery.isEmpty == null || productDoc == null,
    );
  }
}

void openItemSummeryReport(
  BuildContext context,
  ProductDoc productDoc,
  SummeryDoc summeryDoc,
  String? date,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return AllItems(productDoc: productDoc, summeryDoc: summeryDoc, date: date);
  }));
}

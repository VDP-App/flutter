import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/apis/edit_item.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/items/edit_item.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var items = Provider.of<Products>(context);
    var itemDoc = items.doc;
    if (itemDoc == null) return loadingWigit;
    var codeNumList = itemDoc.codeNums;
    return BuildListPage<String>(
      list: codeNumList,
      wrapScaffold: true,
      noDataText: "No Items Found",
      buildChild: (context, code) {
        var item = itemDoc.getItemBy(code: code);
        if (item == null) return const ListTilePage.empty();
        return ListTilePage(
          onClick: () => openEditItem(
            context,
            item,
            itemDoc.collectionNames,
            codeNumList,
          ),
          title: item.name,
          trailingWidgit: TrailingWidgit.text(P2(rs_ + item.rate1.toString())),
          leadingWidgit: LeadingWidgit.text(P1("(${item.code})")),
          preview: Preview.text(P2(item.preview)),
        );
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditItem(
          context,
          null,
          itemDoc.collectionNames,
          codeNumList,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

void openEditItem(BuildContext context, Product? item,
    Iterable<String> collectionNames, List<String> codeNums) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) =>
              EditProduct(context, item, collectionNames, codeNums),
          child: const EditItem(),
        );
      },
    ),
  );
}

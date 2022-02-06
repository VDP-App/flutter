import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/apis/edit_item.dart';
import 'package:vdp/providers/doc/products.dart';
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
    if (codeNumList.isEmpty) return const NoData(text: "No Items Found");
    return Scaffold(
      body: ListView.builder(
        itemCount: codeNumList.length * 2,
        itemBuilder: (context, index) {
          if (index.isOdd) return const Divider(thickness: 1);
          index ~/= 2;
          var item = itemDoc.getItemBy(code: codeNumList[index]);
          if (item == null) return const SizedBox();
          return ListTile(
            trailing: P2(rs_ + item.rate1.toString()),
            subtitle: P2(item.preview),
            leading: P1("(${item.code})"),
            title: T1(item.name),
            onTap: () => openEditItem(
              context,
              item,
              itemDoc.collectionNames,
              codeNumList,
            ),
          );
        },
      ),
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

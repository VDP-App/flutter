import 'package:flutter/material.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/selectors/grid_selector.dart';
import 'package:vdp/widgets/selectors/select_collection.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/utils/modal.dart';

class SelectItem extends StatelessWidget {
  const SelectItem({
    Key? key,
    required this.items,
    required this.onSelect,
  }) : super(key: key);
  final Iterable<Product> items;
  final void Function(Product selectedItem) onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Item Name")),
      body: GridSelector(
        color: Colors.teal,
        count: 3,
        length: items.length,
        builder: (index) {
          var item = items.elementAt(index);
          return GridItem(
            onPress: () {
              onSelect(item);
              Navigator.pop(context);
            },
            title: item.name,
          );
        },
      ),
    );
  }
}

class GetItem extends StatelessWidget {
  const GetItem({
    Key? key,
    required this.items,
    required this.onItemSelect,
  }) : super(key: key);

  final ProductDoc? items;
  final void Function(Product item) onItemSelect;

  @override
  Widget build(BuildContext context) {
    final itemsDoc = items;
    if (itemsDoc == null) {
      return const Center(
        child: P2("No Data found"),
      );
    }
    final modal = Modal(context);
    return SelectCollection(
      collectionNames: itemsDoc.collectionNames,
      editMode: false,
      canPop: false,
      onSelect: (collectionName) {
        var _items = itemsDoc.getItemInCollection(collectionName);
        if (_items == null) {
          modal.openModal("Items Not found", "Can not find the required data");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return SelectItem(
                  items: _items,
                  onSelect: (item) {
                    onItemSelect(item);
                    Navigator.pop(context);
                  });
            }),
          );
        }
      },
    );
  }
}

Future<void> selectItem(
  BuildContext context,
  ProductDoc? doc,
  void Function(Product item) onSelect,
) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return GetItem(
        items: doc,
        onItemSelect: onSelect,
      );
    }),
  );
}

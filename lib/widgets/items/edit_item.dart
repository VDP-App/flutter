import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/edit_item.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/items/get_collection.dart';
import 'package:provider/provider.dart';

class EditItem extends StatelessWidget {
  const EditItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var editProduct = Provider.of<EditProduct>(context, listen: false);
    final item = editProduct.product;
    return BuildPageBody(
      topic: item?.name ?? "New Item",
      wrapScaffold: true,
      children: [
        GetCollectionName(
          collectionNames: editProduct.collectionNames,
          onChange: editProduct.onCollectionNameChanged,
          initialSelectedCollection: item?.collectionName,
        ),
        InputField(
          defaultValue: item?.name,
          onChange: editProduct.onNameChanged,
          lable: "Name",
        ),
        InputField(
          defaultValue: item?.code,
          onChange: editProduct.onCodeChanged,
          lable: "Code",
        ),
        InputField(
          defaultValue: item?.rate1.toString(),
          onChange: editProduct.onRate1Changed,
          lable: "Rate 1",
          asInt: true,
        ),
        InputField(
          defaultValue: item?.rate2.toString(),
          onChange: editProduct.onRate2Changed,
          lable: "Rate 2",
          asInt: true,
        ),
        InputField(
          defaultValue: item?.cgst.toString(),
          onChange: editProduct.onCgstChanged,
          lable: "CGST",
          asInt: true,
        ),
        InputField(
          defaultValue: item?.sgst.toString(),
          onChange: editProduct.onSgstChanged,
          lable: "SGST",
          asInt: true,
        ),
      ],
      floatingActionButton: item == null
          ? const _ActionButton()
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                _ActionButton(),
                SizedBox(height: 30),
                _DeleteButton(),
              ],
            ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var editProduct = Provider.of<EditProduct>(context);
    return FloatingActionButton(
      heroTag: "Delete",
      onPressed: editProduct.removeItem,
      backgroundColor: Colors.red,
      child: editProduct.deleteLoading
          ? loadingIconWigit
          : const Icon(Icons.delete),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var editProduct = Provider.of<EditProduct>(context);
    return Visibility(
      visible: editProduct.isReady,
      child: FloatingActionButton(
        heroTag: "Apply",
        onPressed: editProduct.applyChanges,
        child: editProduct.loading ? loadingIconWigit : const Icon(Icons.check),
      ),
    );
  }
}

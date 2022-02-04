import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/edit_item.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/items/get_collection.dart';
import 'package:provider/provider.dart';

class EditItem extends StatelessWidget {
  const EditItem({Key? key}) : super(key: key);

  Widget inputField({
    required String? defaultValue,
    required void Function(String string) onChange,
    required String lable,
    bool asInt = false,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        controller: TextEditingController(text: defaultValue),
        style: const TextStyle(fontSize: 40),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
        ),
        onChanged: onChange,
        keyboardType: asInt ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget title(String? name) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Text(
        name ?? "New Item",
        style: const TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.w500,
          fontSize: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var editProduct = Provider.of<EditProduct>(context, listen: false);
    final item = editProduct.product;
    return Scaffold(
      appBar: AppBar(
        title: item != null
            ? Text("Item of id: ${item.id}")
            : const Text("Create New Item"),
      ),
      floatingActionButton: SizedBox(
        child: item == null
            ? const _ActionButton()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  _ActionButton(),
                  SizedBox(height: 30),
                  _DeleteButton(),
                ],
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            title(item?.name),
            const SizedBox(height: 50),
            GetCollectionName(
              collectionNames: editProduct.collectionNames,
              onChange: editProduct.onCollectionNameChanged,
              initialSelectedCollection: item?.collectionName,
            ),
            const SizedBox(height: 20),
            inputField(
              defaultValue: item?.name,
              onChange: editProduct.onNameChanged,
              lable: "Name",
            ),
            const SizedBox(height: 20),
            inputField(
              defaultValue: item?.code,
              onChange: editProduct.onCodeChanged,
              lable: "Code",
            ),
            const SizedBox(height: 20),
            inputField(
              defaultValue: item?.rate1.toString(),
              onChange: editProduct.onRate1Changed,
              lable: "Rate 1",
              asInt: true,
            ),
            const SizedBox(height: 20),
            inputField(
              defaultValue: item?.rate2.toString(),
              onChange: editProduct.onRate2Changed,
              lable: "Rate 2",
              asInt: true,
            ),
            const SizedBox(height: 20),
            inputField(
              defaultValue: item?.cgst.toString(),
              onChange: editProduct.onCgstChanged,
              lable: "CGST",
              asInt: true,
            ),
            const SizedBox(height: 20),
            inputField(
              defaultValue: item?.sgst.toString(),
              onChange: editProduct.onSgstChanged,
              lable: "SGST",
              asInt: true,
            ),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/selectors/select_collection.dart';

class GetCollectionName extends StatefulWidget {
  const GetCollectionName({
    Key? key,
    required this.collectionNames,
    required this.onChange,
    required this.initialSelectedCollection,
  }) : super(key: key);

  final Iterable<String> collectionNames;
  final void Function(String selectedCollection) onChange;
  final String? initialSelectedCollection;

  @override
  _GetCollectionNameState createState() => _GetCollectionNameState();
}

class _GetCollectionNameState extends State<GetCollectionName> {
  String? selectedCollection;

  @override
  void initState() {
    super.initState();
    selectedCollection = widget.initialSelectedCollection;
  }

  void setCollectionName(String collectionSelected) {
    if (selectedCollection != collectionSelected) {
      setState(() {
        widget.onChange(collectionSelected);
        selectedCollection = collectionSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCollection(
              collectionNames: widget.collectionNames,
              onSelect: setCollectionName,
              editMode: true,
            ),
          ),
        );
      },
      child: selectedCollection == null
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: T2("Tap to Select Collection!!", color: Colors.red[900]),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: Row(
                children: [
                  T2("Collection:  ", color: Colors.amber[900]),
                  T2(
                    selectedCollection ?? "Select Collection!!",
                    color: selectedCollection == null ? Colors.red[900] : null,
                  ),
                ],
              ),
            ),
    );
  }
}

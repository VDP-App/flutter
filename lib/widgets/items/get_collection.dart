import 'package:flutter/material.dart';
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
          ? Text(
              "Tap to Select Collection!!",
              style: TextStyle(fontSize: 40, color: Colors.red[900]),
            )
          : Row(
              children: [
                Text(
                  "Collection:  ",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.amber[900],
                  ),
                ),
                Text(
                  selectedCollection ?? "Select Collection!!",
                  style: TextStyle(
                    fontSize: 40,
                    color: selectedCollection == null ? Colors.red[900] : null,
                  ),
                ),
              ],
            ),
    );
  }
}

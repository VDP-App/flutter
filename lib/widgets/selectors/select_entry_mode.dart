import 'package:flutter/material.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';

enum SelectedType {
  retailBill,
  wholeSellBill,
  setStock,
  transfer,
  cancleBill,
  produce
}

const _allType = [
  SelectedType.retailBill,
  SelectedType.wholeSellBill,
  SelectedType.cancleBill,
  SelectedType.setStock,
  SelectedType.transfer,
  SelectedType.produce,
];
const _accountentType = [
  SelectedType.retailBill,
  SelectedType.wholeSellBill,
  SelectedType.cancleBill,
];

extension A on SelectedType {
  String get inString {
    return toString()
        .replaceFirst(RegExp(r'SelectedType.'), '')
        .replaceFirst(RegExp(r'S'), " s")
        .replaceFirst(RegExp(r'B'), " b");
  }

  Widget build() {
    return Text(
      inString,
      style: const TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.purple,
      ),
    );
  }

  bool get isBilling {
    switch (this) {
      case SelectedType.retailBill:
        return true;
      case SelectedType.wholeSellBill:
        return true;
      default:
        return false;
    }
  }
}

class SelectEntryMode extends StatelessWidget {
  const SelectEntryMode({
    Key? key,
    required this.selectedType,
    required this.isAccountent,
  }) : super(key: key);
  final SelectedType selectedType;
  final bool isAccountent;

  @override
  Widget build(BuildContext context) {
    final arr = <Widget>[];
    for (var type in isAccountent ? _accountentType : _allType) {
      arr.add(Expanded(
        child: RadioListTile<SelectedType>(
          value: type,
          tileColor: type == selectedType ? Colors.grey[700] : Colors.grey[350],
          groupValue: selectedType,
          onChanged: (x) {
            Navigator.pop(context, x);
          },
          toggleable: true,
          title: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              type.inString,
              style: TextStyle(
                color: type.isBilling
                    ? Colors.green
                    : type != SelectedType.cancleBill
                        ? Colors.pink
                        : Colors.blue,
              ),
            ),
          ),
        ),
      ));
      arr.add(const Divider(thickness: 1));
    }
    final size = MediaQuery.of(context).size;
    if (size.width < size.height || isTablet) {
      arr.add(Expanded(
        child: Container(),
        flex: arr.length ~/ 2,
      ));
    }
    return Scaffold(
      appBar: AppBar(title: appBarTitle("Select Mode")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white70,
          child: Column(children: arr),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:provider/provider.dart';
import 'custom.dart';

class DisplayText extends StatelessWidget {
  const DisplayText(this.text, {Key? key, this.bgColor}) : super(key: key);

  final Color? bgColor;
  final Text text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          color: bgColor,
          child: text,
        ),
      ),
    );
  }
}

class DisplayBuilder extends StatelessWidget {
  const DisplayBuilder({Key? key, required this.cellsIn2d}) : super(key: key);

  final List<List<DisplayCell>> cellsIn2d;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final modeSelector = Provider.of<Widget Function(Auth auth)>(context);
    final widgets = <Widget>[Expanded(child: modeSelector(auth))];
    for (var cells in cellsIn2d) {
      widgets.add(
        Expanded(
          child: Row(children: cells),
        ),
      );
      widgets.add(const Divider(thickness: 1));
    }
    return Column(children: widgets);
  }
}

abstract class DisplayClass extends StatelessWidget {
  const DisplayClass({required Key? key}) : super(key: key);

  DisplayCell showListButton({
    required void Function() showOrders,
    required int length,
  }) {
    return DisplayCell(
      widget: ElevatedButton(
        onPressed: showOrders,
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
        child: DisplayText(Text(length.toString())),
      ),
    );
  }

  List<DisplayCell> itemLine({
    required bool active,
    required String itemNum,
    required void Function() selectItem,
    required void Function() showOrders,
    required int length,
    required void Function() resetItemCode,
  }) {
    return [
      DisplayCell(
        widget: TextButton(
          onPressed: selectItem,
          child: const SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Icons.drive_folder_upload_outlined,
                color: Colors.pink,
              ),
            ),
          ),
        ),
      ),
      DisplayCell(
        onClick: resetItemCode,
        lable: "Item No",
        value: itemNum,
        active: active,
        flex: 3,
      ),
      showListButton(showOrders: showOrders, length: length),
    ];
  }
}

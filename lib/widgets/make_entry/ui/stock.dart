import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/stocking.dart';
import 'package:provider/provider.dart';
import 'package:vdp/widgets/make_entry/display/stock.dart';
import 'builder.dart';

enum KeyAction {
  addQuntity,
  setQuntity,
  negate,
}

extension on KeyAction {
  KeybordKey keyBordKey({
    required void Function(KeybordKeyValue) act,
    required final String text,
    final Color? color,
    final int flex = 1,
  }) {
    return KeybordKey(
      act: act,
      keyValue: this == KeyAction.negate
          ? KeybordKeyValue.action1
          : this == KeyAction.addQuntity
              ? KeybordKeyValue.action2
              : KeybordKeyValue.action3,
      text: text,
      color: color,
      flex: flex,
    );
  }
}

class StockUI<T extends Stocking> extends StatelessWidget {
  const StockUI({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var stocking = Provider.of<T>(context, listen: false);
    final isStocking = T == StockSetting;
    return UIBuilder(
      child: StockDisplay<T>(),
      act: stocking.onClick,
      actions: [
        KeyAction.negate
            .keyBordKey(act: stocking.onClick, text: "±M", color: Colors.pink),
        KeyAction.addQuntity.keyBordKey(
          act: stocking.onClick,
          text: isStocking ? "Add" : "Send",
          color: Colors.blue,
          flex: isStocking ? 1 : 2,
        ),
        if (isStocking)
          KeyAction.setQuntity.keyBordKey(
              act: stocking.onClick, text: "Set", color: Colors.blue),
      ],
    );
  }
}

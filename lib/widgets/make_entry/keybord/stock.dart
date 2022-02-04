import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/stocking.dart';
import 'package:provider/provider.dart';
import 'builder.dart';

enum KeyAction {
  addQuntity,
  setQuntity,
  negate,
}

extension on KeyAction {
  KeybordKey keyBordKey({
    required final String text,
    final Color? color,
    final int flex = 1,
  }) {
    return KeybordKey(
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

class StockKeybord<T extends Stocking> extends StatelessWidget {
  const StockKeybord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stocking = Provider.of<T>(context, listen: false);
    final isStocking = T == StockSetting;
    return KeybordBuilder(
      act: stocking.onClick,
      actions: [
        KeyAction.negate.keyBordKey(text: "±M", color: Colors.pink),
        KeyAction.addQuntity.keyBordKey(
          text: isStocking ? "Add" : "Send",
          color: Colors.blue,
          flex: isStocking ? 1 : 2,
        ),
        if (isStocking)
          KeyAction.setQuntity.keyBordKey(text: "Set", color: Colors.blue),
      ],
    );
  }
}

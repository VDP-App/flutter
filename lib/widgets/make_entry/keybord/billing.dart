import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/billing.dart';
import 'package:provider/provider.dart';
import 'builder.dart';

enum KeyAction {
  quntity,
  price,
  transfer,
}

extension on KeyAction {
  KeybordKeyValue get keybordKeyValue {
    switch (this) {
      case KeyAction.quntity:
        return KeybordKeyValue.action1;
      case KeyAction.price:
        return KeybordKeyValue.action2;
      case KeyAction.transfer:
        return KeybordKeyValue.action3;
    }
  }

  KeybordKey keyBordKey({
    required final String text,
    final IconData? icon,
    final Color? color,
  }) {
    return KeybordKey(
      keyValue: keybordKeyValue,
      text: text,
      color: color,
      icon: icon,
    );
  }
}

class BillingKeybord<T extends Billing> extends StatelessWidget {
  const BillingKeybord({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var billing = Provider.of<T>(context, listen: false);
    return KeybordBuilder(
      act: billing.onClick,
      actions: [
        KeyAction.quntity.keyBordKey(text: "Quntity", color: Colors.blue),
        KeyAction.price.keyBordKey(text: "Price", color: Colors.blue),
        KeyAction.transfer.keyBordKey(text: "Transfer", color: Colors.blue),
      ],
    );
  }
}

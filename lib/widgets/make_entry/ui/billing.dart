import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/billing.dart';
import 'package:provider/provider.dart';
import 'package:vdp/widgets/make_entry/display/billing.dart';
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
    required void Function(KeybordKeyValue) act,
    IconData? icon,
    Color? color,
  }) {
    return KeybordKey(
      act: act,
      keyValue: keybordKeyValue,
      text: text,
      color: color,
      icon: icon,
    );
  }
}

class BillingUI<T extends Billing> extends StatelessWidget {
  const BillingUI({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var billing = Provider.of<T>(context, listen: false);
    return UIBuilder(
      child: BillingDisplay<T>(),
      act: billing.onClick,
      actions: [
        KeyAction.quntity.keyBordKey(
            act: billing.onClick, text: "Quntity", color: Colors.blue),
        KeyAction.price.keyBordKey(
            act: billing.onClick,
            text: T == WholeSellBilling ? "Rate" : "Amount",
            color: Colors.blue),
        KeyAction.transfer.keyBordKey(
            act: billing.onClick, text: "Transfer", color: Colors.blue),
      ],
    );
  }
}

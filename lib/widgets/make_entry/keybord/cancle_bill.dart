import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/cancle_bill.dart';
import 'package:provider/provider.dart';
import 'builder.dart';

class CancleBillKeybord extends StatelessWidget {
  const CancleBillKeybord({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var billing = Provider.of<CancleBill>(context, listen: false);
    return KeybordBuilder(
      act: billing.onClick,
      actions: const [
        KeybordKey(
          keyValue: KeybordKeyValue.action1,
          text: "Cancle",
          color: Colors.blue,
          flex: 3,
        )
      ],
    );
  }
}

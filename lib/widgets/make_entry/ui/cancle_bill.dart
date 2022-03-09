import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/cancle_bill.dart';
import 'package:provider/provider.dart';
import 'package:vdp/widgets/make_entry/display/cancle_bill.dart';
import 'builder.dart';

class CancleBillUI extends StatelessWidget {
  const CancleBillUI({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var billing = Provider.of<CancleBill>(context, listen: false);
    return UIBuilder(
      act: billing.onClick,
      child: const CancleBillDisplay(),
      actions: [
        KeybordKey(
          act: billing.onClick,
          keyValue: KeybordKeyValue.action1,
          text: "Cancle",
          color: Colors.blue,
          flex: 3,
        )
      ],
    );
  }
}

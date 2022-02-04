import 'package:flutter/material.dart';
import 'package:vdp/widgets/make_entry/display/display.dart';
import 'package:vdp/widgets/make_entry/keybord/keybord.dart';
import 'package:vdp/providers/make_entries/make_entries.dart';

class BillingUI<T extends Billing> extends StatelessWidget {
  const BillingUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: BillingDisplay<T>(),
          flex: 3,
          fit: FlexFit.tight,
        ),
        Flexible(child: BillingKeybord<T>(), flex: 5)
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

class StockUI<T extends Stocking> extends StatelessWidget {
  const StockUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: StockDisplay<T>(), flex: 3, fit: FlexFit.tight),
        Flexible(child: StockKeybord<T>(), flex: 5)
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

class CancleBillUI extends StatelessWidget {
  const CancleBillUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Flexible(child: CancleBillDisplay(), flex: 3, fit: FlexFit.tight),
        Flexible(child: CancleBillKeybord(), flex: 5)
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

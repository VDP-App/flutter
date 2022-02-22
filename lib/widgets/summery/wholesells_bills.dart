import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/summery/card_button.dart';

class WholesellBills extends StatelessWidget {
  const WholesellBills({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summery = Provider.of<Summery>(context);
    final wholeSellBills = summery.doc?.wholeSellBills;
    return CardButton(
      iconData: Icons.account_balance_wallet_rounded,
      title: "Wholesell Sells",
      subtitle: "${wholeSellBills?.length} bills",
      color: wholeSellBills == null || wholeSellBills.isEmpty
          ? Colors.grey
          : Colors.deepOrangeAccent,
      onTap: wholeSellBills == null || wholeSellBills.isEmpty
          ? () {}
          : () => openWholeSellsReport(context, wholeSellBills),
      isLoading: summery.isEmpty == null,
    );
  }
}

void openWholeSellsReport(BuildContext context, List<Bill> bills) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    final rows = <List<String>>[];
    final colors = <Color?>[];
    for (var bill in bills) {
      rows.add(["Bill Num: ${bill.billNum}", " ", " ", " "]);
      colors.add(Colors.blueAccent);
      for (var order in bill.orders) {
        rows.add([
          // ? Name
          order.item.name,
          // ? Rate
          rs + order.rate.text,
          // ? Quntity
          order.quntity.text,
          // ? Amount
          rs + order.amount.text,
        ]);
        colors.add(null);
      }
      rows.add([" ", " ", "Total:", rs + bill.totalMoneyInString]);
      colors.add(null);
      rows.add([" ", " ", " ", " "]);
      colors.add(null);
    }
    rows.removeLast();
    colors.removeLast();
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(isTablet ? "Wholesell Summery Report" : "Wholesell"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            DisplayTable.fromString(
              titleNames: const ["Name", "R", "Q", "A"],
              data2D: rows,
              colorRow: colors,
            ),
          ],
        ),
      ),
    );
  }));
}
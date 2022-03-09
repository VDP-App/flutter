import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/summerize_report.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/summerize.dart';
import 'package:vdp/providers/make_entries/custom/formate.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/display_table.dart';

class WholesellBills extends StatelessWidget {
  const WholesellBills({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summerize = Provider.of<Summerize>(context);
    final summerizeDoc = summerize.doc;
    if (summerizeDoc == null) return const SizedBox();
    final wholeSellBills = summerizeDoc.wholeSellBills;
    final totalSold = summerizeDoc.totalWholeSellIncome;
    return CardButton(
      iconData: Icons.account_balance_wallet_rounded,
      title: "Wholesell Sells",
      subtitle: "Net Income $rs $totalSold",
      color: wholeSellBills.isEmpty ? Colors.grey : Colors.deepOrangeAccent,
      onTap: wholeSellBills.isEmpty
          ? () {}
          : () => openWholeSellsReport(context, wholeSellBills),
    );
  }
}

void openWholeSellsReport(
    BuildContext context, List<SummeryOf<List<Bill>>> allBills) {
  var netIncome = 0;
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    final rows = <List<String>>[];
    final colors = <Color?>[];
    for (var bills in allBills) {
      final date = bills.date.substring(5).replaceFirst("-", "/");
      for (var bill in bills.value) {
        rows.add([
          "$date (${bill.billNum})",
          " ",
          bill.note != null ? "NOTE:" : " ",
          bill.note != null ? bill.note ?? "--" : " "
        ]);
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
        netIncome += bill.totalMoney.val;
        rows.add([" ", " ", "Total:", rs + bill.totalMoney.text]);
        colors.add(null);
        rows.add([" ", " ", " ", " "]);
        colors.add(null);
      }
    }
    rows.add(["NET INCOME", " ", " ", rs + formate(netIncome / 1000)]);
    colors.add(Colors.deepPurpleAccent);
    return TablePage.fromString(
      id: "4",
      pageTitle: isTablet ? "Wholesell Summery Report" : "Wholesell",
      titleNames: const ["Name", "R", "Q", "A"],
      data2D: rows,
      colorRow: colors,
    );
  }));
}

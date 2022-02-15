import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/apis/bill_provider.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/cash_counter.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/bills/income_info.dart';
import 'package:vdp/widgets/bills/stock_consumed.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:provider/provider.dart';
import 'package:vdp/widgets/stocks/show_bill.dart';

class DisplayBills extends StatelessWidget {
  const DisplayBills({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final stockID = location.stockID, cashCounterID = location.cashCounterID;
    if (stockID == null || cashCounterID == null) {
      return SelectLocationButton.fromLocation(location, "To See bills");
    }
    var cashCounter = Provider.of<CashCounter>(context);
    final doc = cashCounter.doc;
    if (doc == null) return loadingWigit;
    return BuildListPage<Bill>(
      list: doc.bills,
      noDataText: "No Bills Found",
      wrapScaffold: true,
      startWith: [
        const StockConsumed(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IncomeInfo(amount: doc.offlineIncome.text, cashIn: CashIn.offline),
          IncomeInfo(amount: doc.onlineIncome.text, cashIn: CashIn.online)
        ]),
      ],
      buildChild: (context, bill) {
        return ListTilePage(
          title: parseCode(bill.billNum),
          onClick: () => openBill(context, bill, stockID, cashCounterID),
          preview: Preview.text(P3(rs_ + bill.totalMoneyInString)),
          leadingWidgit: LeadingWidgit.text(
            P2(bill.isWholeSell ? "( W )" : "( R )"),
          ),
          trailingWidgit: TrailingWidgit.actionButton(
            question: "Cencle Bill?",
            action: () {
              return cashCounter.cancelBill(bill.billNum);
            },
            color: Colors.red,
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}

void openBill(
  BuildContext context,
  Bill bill,
  String stockID,
  String cashCounterID,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ChangeNotifierProvider(
      create: (context) => BillProvider(context, bill, stockID, cashCounterID),
      child: const ShowBill(),
    );
  }));
}

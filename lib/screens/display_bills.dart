import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/summerize_report.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/apis/bill_provider.dart';
import 'package:vdp/providers/apis/blutooth.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/cash_counter.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/bills/income_info.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:provider/provider.dart';
import 'package:vdp/widgets/stocks/show_bill.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/summery.dart';

class DisplayBills extends StatelessWidget {
  const DisplayBills({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<Location, CashCounter>(
      create: (context) => CashCounter(context),
      update: (context, location, previous) {
        previous ??= CashCounter(context);
        final stockID = location.stockID,
            cashCounterID = location.cashCounterID;
        if (stockID != null && cashCounterID != null) {
          previous.update(stockID, cashCounterID);
        }
        return previous;
      },
      lazy: false,
      child: const _DisplayBills(),
    );
  }
}

class _DisplayBills extends StatelessWidget {
  const _DisplayBills({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final stockID = location.stockID, cashCounterID = location.cashCounterID;
    if (stockID == null || cashCounterID == null) {
      return SelectLocationButton.fromLocation(location, "To See bills");
    }
    var cashCounter = Provider.of<CashCounter>(context);
    final printBill = Provider.of<BlutoothProvider>(context).printBill;
    final doc = cashCounter.doc;
    if (doc == null) return loadingWigit;
    return BuildListPage<Bill>(
      list: doc.bills,
      noDataText: "No Bills Found",
      wrapScaffold: true,
      startWith: [
        const _CancledBills(),
        const _WholesellBills(),
        const RetailConsumption(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IncomeInfo(amount: doc.offlineIncome.text, cashIn: CashIn.offline),
          IncomeInfo(amount: doc.onlineIncome.text, cashIn: CashIn.online)
        ]),
      ],
      buildChild: (context, bill) {
        return ListTilePage(
          title: parseCode(bill.billNum),
          onClick: () => openBill(context, bill, stockID, cashCounterID),
          preview: Preview.text(P3(rs_ + bill.totalMoney.text)),
          leadingWidgit: LeadingWidgit.text(
            P2(bill.isWholeSell ? "( W )" : "( R )"),
          ),
          trailingWidgit: TrailingWidgit.actionButton(
            question: "Print Bill?",
            action: () {
              return printBill(bill.toGstBill(), true);
            },
            color: Colors.deepPurpleAccent,
            icon: const Icon(Icons.print),
          ),
        );
      },
    );
  }
}

class _WholesellBills extends StatelessWidget {
  const _WholesellBills({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cashCounter = Provider.of<CashCounter>(context);
    final bills = cashCounter.doc?.bills;
    final wholeSellBills = <Bill>[];
    for (var bill in bills ?? <Bill>[]) {
      if (bill.isWholeSell) wholeSellBills.add(bill);
    }
    return CardButton(
      iconData: Icons.account_balance_wallet_rounded,
      title: "Wholesell Sells",
      subtitle: "${wholeSellBills.length} bills",
      color: bills == null || wholeSellBills.isEmpty
          ? Colors.grey
          : Colors.deepOrangeAccent,
      onTap: bills == null || wholeSellBills.isEmpty
          ? () {}
          : () => openWholeSellsReport(
              context, [SummeryOf("Today", wholeSellBills)]),
      isLoading: bills == null,
    );
  }
}

void openBill(
  BuildContext context,
  Bill bill,
  String stockID,
  String cashCounterID, [
  bool isFixed = false,
]) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ChangeNotifierProvider(
      create: (context) => BillProvider(context, bill, stockID, cashCounterID),
      child: ShowBill(isFixed: isFixed),
    );
  }));
}

class _CancledBills extends StatelessWidget {
  const _CancledBills({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productsDoc = products.doc;
    final cashCounter = Provider.of<CashCounter>(context);
    final cashCounterDoc = cashCounter.doc;
    final location = Provider.of<Location>(context);
    final stockID = location.stockID, cashCounterID = location.cashCounterID;
    return CardButton(
      title: "Cancled Bills",
      // subtitle: "Stock Sold in Retail",
      iconData: Icons.cancel_outlined,
      color: Colors.red,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: appBarTitle(isTablet ? "Vardayani Dairy Products" : "VDP"),
            ),
            body: BuildListPage<Bill>(
              list: cashCounterDoc!.cancledBills,
              noDataText: "No Bills Found",
              wrapScaffold: true,
              buildChild: (context, bill) {
                return ListTilePage(
                  title: parseCode(bill.billNum),
                  onClick: () =>
                      openBill(context, bill, stockID!, cashCounterID!),
                  preview: Preview.text(P3(rs_ + bill.totalMoney.text)),
                  leadingWidgit: LeadingWidgit.text(
                    P2(bill.isWholeSell ? "( W )" : "( R )"),
                  ),
                );
              },
            ),
          );
        }));
      },
      isLoading: cashCounterDoc == null || productsDoc == null,
    );
  }
}

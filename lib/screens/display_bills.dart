import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/cash_counter.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/bills/bill_tile.dart';
import 'package:vdp/widgets/bills/income_info.dart';
import 'package:vdp/widgets/bills/stock_consumed.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:provider/provider.dart';

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
      child: const _Bills(),
    );
  }
}

class _Bills extends StatelessWidget {
  const _Bills({Key? key}) : super(key: key);

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
    if (doc.bills.isEmpty) return const NoData(text: "No Bills Found");
    return Column(
      children: [
        const StockConsumed(),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IncomeInfo(amount: doc.offlineIncome.text, cashIn: CashIn.offline),
          IncomeInfo(amount: doc.onlineIncome.text, cashIn: CashIn.online)
        ]),
        const Divider(thickness: 2, height: 50),
        Expanded(
          child: Scrollable(viewportBuilder: (context, _) {
            return ListView.builder(
                itemCount: doc.bills.length * 2,
                itemBuilder: (context, i) {
                  if (i.isOdd) return const Divider(thickness: 1.5);
                  final bill = doc.bills.elementAt(i ~/ 2);
                  return BillTile(
                    bill: bill,
                    cancelBill: cashCounter.cancelBill,
                    cashCounterID: cashCounterID,
                    stockID: stockID,
                  );
                });
          }),
        )
      ],
    );
  }
}

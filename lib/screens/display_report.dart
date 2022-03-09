import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:vdp/widgets/summery/summery.dart';

// ! previous Date
// ?    item-report => Table
// ?    retail-sells => Table
// ?    whole-sells => List
// ?    stockChanges => List

class DisplayReport extends StatelessWidget {
  const DisplayReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final stockID = location.stockID, cashCounterID = location.cashCounterID;
    if (stockID == null || cashCounterID == null) {
      return SelectLocationButton.fromLocation(location, "To See Report");
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: const [
          Center(child: H2("Today's Stock")),
          Divider(thickness: 2),
          _TodayOptions(),
          Divider(thickness: 2.5),
          Center(child: H2("Summery Report")),
          PickDate(),
          Divider(thickness: 2),
          ItemSummery(),
          RetailSellsReport(),
          WholesellBills(),
          StockChangesSummery(),
        ],
      ),
    );
  }
}

class _TodayOptions extends StatelessWidget {
  const _TodayOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [RetailConsumption(), CurrentStock()],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

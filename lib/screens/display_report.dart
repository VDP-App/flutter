import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';

class DisplayReport extends StatelessWidget {
  const DisplayReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final stockID = location.stockID, cashCounterID = location.cashCounterID;
    if (stockID == null || cashCounterID == null) {
      return SelectLocationButton.fromLocation(location, "To See ");
    }
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: H1("Comming Soon")),
    );
  }
}
// ! today
// ?    stockConsumed
// ?    currentStock
// ! previous Date
// ?    retail-Table
// ?    wholeSell-List
// ?    stockChanges-List


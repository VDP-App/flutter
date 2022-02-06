import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:vdp/widgets/stocks/show_stock_changes.dart';
import 'package:provider/provider.dart';

class DisplayStockChanges extends StatelessWidget {
  const DisplayStockChanges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final stockID = location.stockID;
    if (stockID == null) {
      return SelectLocationButton.fromLocation(
        location,
        "To See stock entries",
      );
    }
    final stock = Provider.of<Stock>(context);
    final entries = stock.doc?.entry;
    if (entries == null) return loadingWigit;
    if (entries.isEmpty) return const NoData(text: "No Entries Found");
    return ListView.builder(
      itemCount: entries.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider(thickness: 1.5);
        var entry = entries.elementAt(i ~/ 2);
        return ListTile(
          onTap: () => openEntry(context, entry),
          trailing: entry.transferTo != null
              ? const IconT1(Icons.send, color: Colors.blue)
              : entry.transferFrom != null
                  ? const IconT1(
                      Icons.get_app_rounded,
                      color: Colors.green,
                    )
                  : const IconT1(
                      Icons.change_history_rounded,
                      color: Colors.orange,
                    ),
          title: entry.transferTo != null
              ? const T1("Stock Sent")
              : entry.transferFrom != null
                  ? const T1("Stock Recive")
                  : const T1("Stock Changed"),
          subtitle: P2(entry.preview),
        );
      },
    );
  }
}

void openEntry(BuildContext context, Entry entry) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ShowStockChanges(entry: entry);
  }));
}

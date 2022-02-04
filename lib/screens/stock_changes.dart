import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/loading.dart';
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
      return SelectLocationButton.fromLocation(location);
    }
    final stock = Provider.of<Stock>(context);
    final entries = stock.doc?.entry;
    if (entries == null) return loadingWigit;
    if (entries.isEmpty) return const NoData(text: "No Entries Found");
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: ListView.builder(
        itemCount: entries.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider(thickness: 1.5);
          var entry = entries.elementAt(i ~/ 2);
          const titleStyle = TextStyle(fontSize: 35);
          return ListTile(
            onTap: () => openEntry(context, entry),
            trailing: entry.transferTo != null
                ? const Icon(Icons.send, size: 35, color: Colors.blue)
                : entry.transferFrom != null
                    ? const Icon(
                        Icons.get_app_rounded,
                        size: 35,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.change_history_rounded,
                        size: 35,
                        color: Colors.orange,
                      ),
            title: entry.transferTo != null
                ? const Text("Stock Sent", style: titleStyle)
                : entry.transferFrom != null
                    ? const Text("Stock Recive", style: titleStyle)
                    : const Text("Stock Changed", style: titleStyle),
            subtitle: Text(
              entry.preview,
              style: const TextStyle(fontSize: 25),
            ),
          );
        },
      ),
    );
  }
}

void openEntry(BuildContext context, Entry entry) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShowStockChanges(entry: entry),
      ),
    );
  }));
}

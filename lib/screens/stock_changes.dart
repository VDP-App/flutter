import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:vdp/widgets/stocks/show_stock_changes.dart';
import 'package:provider/provider.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/stock_changes.dart';

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
    return BuildListPage<Entry>(
      wrapScaffold: true,
      startWith: const [_StockChangesSummery()],
      buildChild: (context, entry) {
        return ListTilePage(
          leadingWidgit: LeadingWidgit.text(
            P2(entry.entryNum),
          ),
          title: entry.transferTo != null
              ? "Stock Sent"
              : entry.transferFrom != null
                  ? "Stock Recive"
                  : "Stock Changed",
          preview: Preview.text(P2(entry.preview)),
          onClick: () => openEntry(context, entry, stockID),
          trailingWidgit: TrailingWidgit.icon(
            entry.transferTo != null
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
          ),
        );
      },
      noDataText: "No Entries Found",
      list: entries,
    );
  }
}

class _StockChangesSummery extends StatelessWidget {
  const _StockChangesSummery({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<Stock>(context);
    final entries = stock.doc?.entry;
    return CardButton(
      iconData: Icons.change_circle_sharp,
      title: "Stock Changes",
      subtitle: "${entries?.length} entries",
      color:
          entries == null || entries.isEmpty ? Colors.grey : Colors.pinkAccent,
      onTap: entries == null || entries.isEmpty
          ? () {}
          : () => openStockChangesSummeryReport(context, entries, "TODAY"),
    );
  }
}

void openEntry(
  BuildContext context,
  Entry entry,
  String stockID, [
  bool isFixed = false,
]) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ShowStockChanges(entry: entry, stockID: stockID, isFixed: isFixed);
  }));
}

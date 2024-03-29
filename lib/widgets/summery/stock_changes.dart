import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/documents/utils/summerize_report.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/providers/doc/summerize.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/display_table.dart';

class StockChangesSummery extends StatelessWidget {
  const StockChangesSummery({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summerize = Provider.of<Summerize>(context);
    final entries = summerize.doc?.entries;
    if (entries == null) return const SizedBox();
    return CardButton(
      iconData: Icons.change_circle_sharp,
      title: "Stock Changes",
      subtitle: "Tap to see entries",
      color: entries.isEmpty ? Colors.grey : Colors.pinkAccent,
      onTap: entries.isEmpty
          ? () {}
          : () => openStockChangesSummeryReport(context, entries),
    );
  }
}

void openStockChangesSummeryReport(
  BuildContext context,
  List<SummeryOf<List<Entry>>> allEntries,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    final rows = <List<String>>[];
    final colors = <Color?>[];
    for (var entries in allEntries) {
      final date = entries.date.substring(5).replaceFirst("-", "/");
      for (var entry in entries.value) {
        rows.add([
          "$date (${entry.entryNum})",
          " ",
          entry.note != null ? "NOTE:" : " ",
          entry.note != null ? entry.note ?? "--" : " ",
        ]);
        colors.add(Colors.blueAccent);
        final transferFrom = getStockInfo(entry.transferFrom);
        final transferTo = getStockInfo(entry.transferTo);
        if (transferTo != null) {
          rows.add(["Send To: ${transferTo.name}", " ", "-->", " "]);
          colors.add(Colors.deepOrangeAccent);
          for (var changes in entry.stockChanges) {
            rows.add([changes.item.name, changes.stockInc.text, " ", " "]);
            colors.add(null);
          }
        } else if (transferFrom != null) {
          rows.add(["Send From: ${transferFrom.name}", " ", "<--", " "]);
          colors.add(Colors.deepPurpleAccent);
          for (var changes in entry.stockChanges) {
            rows.add([changes.item.name, changes.stockInc.text, " ", " "]);
            colors.add(null);
          }
        } else {
          for (var changes in entry.stockChanges) {
            rows.add([
              changes.item.name,
              changes.stockInc.text,
              ...(changes.type == StockSetType.increment
                  ? [" ", " "]
                  : [changes.stockBefore.text, changes.stockAfter.text]),
            ]);
            colors.add(null);
          }
        }

        rows.add([" ", " ", " ", " "]);
        colors.add(null);
      }
    }

    return TablePage.fromString(
      id: "3",
      pageTitle: isTablet ? "Stock Changes" : "S. Changes",
      titleNames: const ["Name", "+Q", "Set", "To"],
      data2D: rows,
      colorRow: colors,
    );
  }));
}

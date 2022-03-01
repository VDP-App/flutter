import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/widgets/summery/card_button.dart';
import 'package:vdp/widgets/summery/display_table.dart';

class StockChangesSummery extends StatelessWidget {
  const StockChangesSummery({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summery = Provider.of<Summery>(context);
    final entries = summery.doc?.entries;
    return CardButton(
      iconData: Icons.change_circle_sharp,
      title: "Stock Changes",
      subtitle: "${entries?.length} entries",
      color:
          entries == null || entries.isEmpty ? Colors.grey : Colors.pinkAccent,
      onTap: entries == null || entries.isEmpty
          ? () {}
          : () => openStockChangesSummeryReport(context, entries),
    );
  }
}

void openStockChangesSummeryReport(BuildContext context, List<Entry> entries) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    final rows = <List<String>>[];
    final colors = <Color?>[];
    for (var entry in entries) {
      rows.add([
        "Entry Num: ${entry.entryNum}",
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
    return TablePage.fromString(
      pageTitle: isTablet ? "Stock Changes" : "S. Changes",
      titleNames: const ["Name", "+Q", "Set", "To"],
      data2D: rows,
      rowCellWidth: [width5char, width5char, width5char],
      colorRow: colors,
    );
  }));
}

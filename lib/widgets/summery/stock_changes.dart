import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/widgets/summery/card_button.dart';

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
      rows.add(["Entry Num: ${entry.entryNum}", " ", " ", " "]);
      colors.add(Colors.blueAccent);
      final transferFrom = getStockInfo(entry.transferFrom);
      final transferTo = getStockInfo(entry.transferTo);
      if (transferTo != null) {
        rows.add(["Send To: ${transferTo.name}", " ", " ", "-->"]);
        colors.add(Colors.deepOrangeAccent);
      } else if (transferFrom != null) {
        rows.add(["Send From: ${transferFrom.name}", " ", " ", "<--"]);
        colors.add(Colors.deepPurpleAccent);
      }
      for (var changes in entry.stockChanges) {
        rows.add([
          changes.item.name,
          changes.stockBefore.text,
          changes.stockInc.text,
          changes.stockAfter.text,
        ]);
        colors.add(null);
      }
      rows.add([" ", " ", " ", " "]);
      colors.add(null);
    }
    return Scaffold(
      appBar:
          AppBar(title: appBarTitle(isTablet ? "Stock Changes" : "S. Changes")),
      body: ListView(
        children: [
          DisplayTable.fromString(
            titleNames: const ["Name", "B", "+Q", "A"],
            data2D: rows,
            colorRow: colors,
          )
        ],
      ),
    );
  }));
}

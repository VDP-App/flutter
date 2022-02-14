import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/page_utils.dart';

class ShowStockChanges extends StatelessWidget {
  const ShowStockChanges({Key? key, required this.entry, required this.stockID})
      : super(key: key);
  final Entry entry;
  final String stockID;

  static final _cancleStockChanges = CancleEntryOnCloud().cancleStockChanges;

  @override
  Widget build(BuildContext context) {
    final sendBy = entry.senderUid;
    final sendFrom = entry.transferFrom;
    final sendTo = entry.transferTo;
    return BuildPageBody(
      title: entry.transferTo != null
          ? "Stock Send"
          : entry.transferFrom != null
              ? "Stock Recive"
              : "Stock Changed",
      wrapScaffold: true,
      children: [
        InfoCell("Created By", getUserInfo(entry.uid)?.name),
        if (sendFrom != null && sendBy != null) ...[
          InfoCell("Send By", getUserInfo(sendBy)?.name),
          InfoCell("Send From", getStockInfo(sendFrom)?.name),
        ],
        if (sendTo != null) InfoCell("Send To", getStockInfo(sendTo)?.name),
      ],
      trailing: [_StockChangesTable(changes: entry.stockChanges)],
      floatingActionButton: ActionButton(
        action: () => _cancleStockChanges(entry.entryNum, stockID),
        color: Colors.red,
        icon: const Icon(Icons.delete),
        question: "Are You sure you like to delete Stock",
      ),
    );
  }
}

class _StockChangesTable extends StatelessWidget {
  const _StockChangesTable({Key? key, required this.changes}) : super(key: key);
  final List<StockChangesInEntry> changes;
  @override
  Widget build(BuildContext context) {
    return DisplayTable(
      titleNames: const ["Name", "B", "+ Q", "A"],
      data2D: changes.map(
        (e) => [
          DisplayTableCell(e.item.name),
          DisplayTableCell(e.stockBefore.text),
          DisplayTableCell(
            e.stockInc.val.isNegative ? e.stockInc.text : "+" + e.stockInc.text,
            color: e.stockInc.val.isNegative ? Colors.red : Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
          DisplayTableCell(e.stockAfter.text),
        ],
      ),
    );
  }
}

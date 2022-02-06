import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/typography.dart';

class ShowStockChanges extends StatelessWidget {
  const ShowStockChanges({Key? key, required this.entry}) : super(key: key);
  final Entry entry;

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
    );
  }
}

class _StockChangesTable extends StatelessWidget {
  const _StockChangesTable({Key? key, required this.changes}) : super(key: key);
  final List<StockChangesInEntry> changes;
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: T2("Name", color: Colors.purple)),
        DataColumn(label: T2("Before", color: Colors.purple)),
        DataColumn(label: T2("+ Q", color: Colors.purple)),
        DataColumn(label: T2("After", color: Colors.purple)),
      ],
      rows: changes
          .map(
            (e) => DataRow(
                color: MaterialStateProperty.resolveWith(
                  (_) => e.stockInc.val.isNegative ? Colors.red : Colors.green,
                ),
                cells: [
                  DataCell(P3(e.item.name, color: Colors.white)),
                  DataCell(P3(e.stockBefore.text, color: Colors.white)),
                  DataCell(P3(e.stockInc.text, color: Colors.white)),
                  DataCell(P3(e.stockAfter.text, color: Colors.white)),
                ]),
          )
          .toList(),
    );
  }
}

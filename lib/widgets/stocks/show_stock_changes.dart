import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/providers/doc/config.dart';

class ShowStockChanges extends StatelessWidget {
  const ShowStockChanges({Key? key, required this.entry}) : super(key: key);
  final Entry entry;

  Container infoCell(String lable, String? info) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          Text(
            "$lable:",
            style: const TextStyle(fontSize: 30, color: Colors.purple),
          ),
          Text(info ?? "-- * --", style: const TextStyle(fontSize: 30)),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Center get title {
    return Center(
      child: Text(
        entry.transferTo != null
            ? "Stock Send"
            : entry.transferFrom != null
                ? "Stock Recive"
                : "Stock Changed",
        style: const TextStyle(fontSize: 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sendBy = entry.senderUid;
    final sendFrom = entry.transferFrom;
    final sendTo = entry.transferTo;
    return ListView(
      children: [
        title,
        const SizedBox(height: 20),
        infoCell("Created By", getUserInfo(entry.uid)?.name),
        const SizedBox(height: 10),
        if (sendFrom != null && sendBy != null) ...[
          infoCell("Send By", getUserInfo(sendBy)?.name),
          const SizedBox(height: 10),
          infoCell("Send From", getStockInfo(sendFrom)?.name),
          const SizedBox(height: 10),
        ],
        if (sendTo != null) ...[
          infoCell("Send To", getStockInfo(sendTo)?.name),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 40),
        _StockChangesTable(changes: entry.stockChanges),
      ],
    );
  }
}

class _StockChangesTable extends StatelessWidget {
  const _StockChangesTable({Key? key, required this.changes}) : super(key: key);
  final List<StockChangesInEntry> changes;
  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: const TextStyle(fontSize: 40),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.purple),
      dataTextStyle: const TextStyle(fontSize: 30, color: Colors.white),
      columns: const [
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Before")),
        DataColumn(label: Text("+ Q")),
        DataColumn(label: Text("After")),
      ],
      rows: changes
          .map(
            (e) => DataRow(
                color: MaterialStateProperty.resolveWith(
                  (_) => e.stockInc.val.isNegative ? Colors.red : Colors.green,
                ),
                cells: [
                  DataCell(Text(e.item.name)),
                  DataCell(Text(e.stockBefore.text)),
                  DataCell(Text(e.stockInc.text)),
                  DataCell(Text(e.stockAfter.text)),
                ]),
          )
          .toList(),
    );
  }
}

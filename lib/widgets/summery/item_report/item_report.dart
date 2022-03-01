import 'package:flutter/material.dart';
import 'package:vdp/documents/summery.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/stock_entry.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/screens/screen.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

class FullItemReport extends StatelessWidget {
  const FullItemReport({
    Key? key,
    required this.product,
    required this.summeryDoc,
  }) : super(key: key);
  final Product product;
  final SummeryDoc summeryDoc;
  @override
  Widget build(BuildContext context) {
    final productReport = summeryDoc.productReports[product.id];
    final endStock =
        summeryDoc.stockAtEnd[product.id] ?? FixedNumber.fromInt(0);
    const emptyCell = DisplayTableCell.empty();
    const emptyRow = [
      emptyCell,
      emptyCell,
      emptyCell,
      emptyCell,
      emptyCell,
    ];
    final rows = [
      [
        DisplayTableCell("Initial Stock"),
        emptyCell,
        DisplayTableCell(
          FixedNumber.fromInt(
            endStock.val - (productReport?.netQuntityChange ?? 0),
          ).text,
        ),
        emptyCell,
        emptyCell,
      ],
      emptyRow,
    ];
    final colors = [Colors.redAccent, null];
    if (productReport != null) {
      if (productReport.stockChanges.isNotEmpty) {
        rows.add([
          DisplayTableCell("Internal Changes"),
          DisplayTableCell("Num"),
          emptyCell,
          DisplayTableCell("Set"),
          DisplayTableCell("To"),
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockChanges.entries) {
          rows.add([
            item.value.note != null
                ? DisplayTableCell(
                    "NOTE: ${item.value.note ?? "--"}",
                    onTap: () => openEntry(
                      context,
                      summeryDoc.entries[item.key],
                      currentStockID ?? "",
                      true,
                    ),
                  )
                : emptyCell,
            DisplayTableCell(
              "${item.key}",
              onTap: () => openEntry(
                context,
                summeryDoc.entries[item.key],
                currentStockID ?? "",
                true,
              ),
            ),
            DisplayTableCell(item.value.stockInc.text),
            ...item.value.type == StockSetType.increment
                ? [emptyCell, emptyCell]
                : [
                    DisplayTableCell(item.value.stockBefore.text),
                    DisplayTableCell(item.value.stockAfter.text),
                  ]
          ]);
          colors.add(null);
        }
        rows.add(emptyRow);
        colors.add(null);
      }

      if (productReport.retail.isNotEmpty) {
        rows.add([
          DisplayTableCell("Retail"),
          DisplayTableCell("Rate"),
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.retail.entries) {
          rows.add([
            DisplayTableCell(" "),
            DisplayTableCell(rs + item.key.text),
            DisplayTableCell(item.value.negateText),
            emptyCell,
            emptyCell,
          ]);
          colors.add(null);
        }
        rows.add(emptyRow);
        colors.add(null);
      }

      if (productReport.wholeSell.isNotEmpty) {
        rows.add([
          DisplayTableCell("WholeSell"),
          DisplayTableCell("Num"),
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.wholeSell.entries) {
          rows.add([
            emptyCell,
            DisplayTableCell(
              "${item.key}",
              onTap: () => openBill(
                context,
                summeryDoc.wholeSellBills[item.key],
                currentStockID ?? "",
                "",
                true,
              ),
            ),
            DisplayTableCell(item.value.negateText),
            emptyCell,
            emptyCell,
          ]);
          colors.add(null);
        }
        rows.add(emptyRow);
        colors.add(null);
      }

      if (productReport.stockSend.isNotEmpty) {
        rows.add([
          DisplayTableCell("Send"),
          DisplayTableCell("Num"),
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockSend.entries) {
          rows.add([
            emptyCell,
            DisplayTableCell(
              "${item.key}",
              onTap: () => openEntry(
                context,
                summeryDoc.entries[item.key],
                currentStockID ?? "",
                true,
              ),
            ),
            DisplayTableCell(item.value.text),
            emptyCell,
            emptyCell,
          ]);
          colors.add(null);
        }
        rows.add(emptyRow);
        colors.add(null);
      }

      if (productReport.stockRecive.isNotEmpty) {
        rows.add([
          DisplayTableCell("Recive"),
          DisplayTableCell("Num"),
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockRecive.entries) {
          rows.add([
            emptyCell,
            DisplayTableCell(
              "${item.key}",
              onTap: () => openEntry(
                context,
                summeryDoc.entries[item.key],
                currentStockID ?? "",
                true,
              ),
            ),
            DisplayTableCell(item.value.text),
            emptyCell,
            emptyCell,
          ]);
          colors.add(null);
        }
        rows.add(emptyRow);
        colors.add(null);
      }
    }
    rows.add([
      DisplayTableCell("Final Stock"),
      emptyCell,
      DisplayTableCell(endStock.text),
      emptyCell,
      emptyCell,
    ]);
    colors.add(Colors.redAccent);

    return ListView(children: [
      const SizedBox(height: 20),
      H1(product.name),
      const SizedBox(height: 20),
      DisplayTable(
        titleNames: const ["Type", "@", "+Q", " ", " "],
        data2D: rows,
        colorRow: colors,
      )
    ]);
  }
}

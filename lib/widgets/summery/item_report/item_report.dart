import 'package:flutter/material.dart';
import 'package:vdp/documents/summerize.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/screens/screen.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

class FullItemReport extends StatelessWidget {
  const FullItemReport({
    Key? key,
    required this.product,
    required this.summerizeDoc,
  }) : super(key: key);
  final Product product;
  final SummerizeDoc summerizeDoc;
  @override
  Widget build(BuildContext context) {
    final productOverview = summerizeDoc.getTotalReportOf(product);
    final productReport = summerizeDoc.getReportOf(product);
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
        DisplayTableCell(productOverview?.startStock.text ?? "--"),
        emptyCell,
        emptyCell,
      ],
      emptyRow,
    ];
    final colors = [Colors.redAccent, null];
    if (productReport != null) {
      if (productReport.stockInternalyAdded.isNotEmpty) {
        rows.add([
          DisplayTableCell("Internaly Added"),
          emptyCell,
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockInternalyAdded) {
          rows.add([
            item.note != null
                ? DisplayTableCell(
                    "NOTE: ${item.note ?? "--"}",
                    onTap: () {
                      final e = summerizeDoc.getEntryOf(item);
                      if (e == null) return;
                      openEntry(
                        context,
                        e,
                        currentStockID ?? "",
                        true,
                      );
                    },
                  )
                : emptyCell,
            DisplayTableCell(
              item.date.substring(5).replaceFirst("-", "/"),
              onTap: () {
                final e = summerizeDoc.getEntryOf(item);
                if (e == null) return;
                openEntry(
                  context,
                  e,
                  currentStockID ?? "",
                  true,
                );
              },
            ),
            DisplayTableCell(item.value.stockInc.text),
            emptyCell,
            emptyCell,
          ]);
          colors.add(null);
        }
        rows.add(emptyRow);
        colors.add(null);
      }
      if (productReport.stockInternalyRemoved.isNotEmpty) {
        rows.add([
          DisplayTableCell("Internaly Removed"),
          emptyCell,
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockInternalyRemoved) {
          rows.add([
            item.note != null
                ? DisplayTableCell(
                    "NOTE: ${item.note ?? "--"}",
                    onTap: () {
                      final e = summerizeDoc.getEntryOf(item);
                      if (e == null) return;
                      openEntry(
                        context,
                        e,
                        currentStockID ?? "",
                        true,
                      );
                    },
                  )
                : emptyCell,
            DisplayTableCell(
              item.date.substring(5).replaceFirst("-", "/"),
              onTap: () {
                final e = summerizeDoc.getEntryOf(item);
                if (e == null) return;
                openEntry(
                  context,
                  e,
                  currentStockID ?? "",
                  true,
                );
              },
            ),
            DisplayTableCell(item.value.stockInc.text),
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
          emptyCell,
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockRecive) {
          rows.add([
            emptyCell,
            DisplayTableCell(
              item.date.substring(5).replaceFirst("-", "/"),
              onTap: () {
                final e = summerizeDoc.getEntryOf(item);
                if (e == null) return;
                openEntry(
                  context,
                  e,
                  currentStockID ?? "",
                  true,
                );
              },
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
            emptyCell,
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
          emptyCell,
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.wholeSell) {
          rows.add([
            emptyCell,
            DisplayTableCell(
              item.date.substring(5).replaceFirst("-", "/"),
              onTap: () {
                final b = summerizeDoc.getBillOf(item);
                if (b == null) return;
                openBill(
                  context,
                  b,
                  currentStockID ?? "",
                  "",
                  true,
                );
              },
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
          emptyCell,
          emptyCell,
          emptyCell,
          emptyCell,
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockSend) {
          rows.add([
            emptyCell,
            DisplayTableCell(
              item.date.substring(5).replaceFirst("-", "/"),
              onTap: () {
                final e = summerizeDoc.getEntryOf(item);
                if (e == null) return;
                openEntry(
                  context,
                  e,
                  currentStockID ?? "",
                  true,
                );
              },
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
      if (productReport.stockInternalErr.isNotEmpty) {
        rows.add([
          DisplayTableCell("Internal Error"),
          emptyCell,
          emptyCell,
          DisplayTableCell("Set"),
          DisplayTableCell("To"),
        ]);
        colors.add(Colors.blueAccent);
        for (var item in productReport.stockInternalErr) {
          rows.add([
            item.note != null
                ? DisplayTableCell(
                    "NOTE: ${item.note ?? "--"}",
                    onTap: () {
                      final e = summerizeDoc.getEntryOf(item);
                      if (e == null) return;
                      openEntry(
                        context,
                        e,
                        currentStockID ?? "",
                        true,
                      );
                    },
                  )
                : emptyCell,
            DisplayTableCell(
              item.date.substring(5).replaceFirst("-", "/"),
              onTap: () {
                final e = summerizeDoc.getEntryOf(item);
                if (e == null) return;
                openEntry(
                  context,
                  e,
                  currentStockID ?? "",
                  true,
                );
              },
            ),
            DisplayTableCell(item.value.stockInc.text),
            DisplayTableCell(item.value.stockBefore.text),
            DisplayTableCell(item.value.stockAfter.text),
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
      DisplayTableCell(productOverview?.endStock.text ?? "--"),
      emptyCell,
      emptyCell,
    ]);
    colors.add(Colors.redAccent);

    return ListView(children: [
      const SizedBox(height: 20),
      H1(product.name),
      const SizedBox(height: 20),
      DisplayTable(
        titleNames: const ["Type", "Date", "+Q", " ", " "],
        data2D: rows,
        colorRow: colors,
      )
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/summery.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/documents/utils/report.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/summery/item_report/item_report.dart';

class AllItems extends StatefulWidget {
  const AllItems({
    Key? key,
    required this.productDoc,
    required this.summeryDoc,
  }) : super(key: key);
  final ProductDoc productDoc;
  final SummeryDoc summeryDoc;

  Map<String, FixedProductReport> get productReports =>
      summeryDoc.productReports;

  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  bool displayIn3s = sharedPreferences.getBool("displayIn3s") ?? true;

  void toggelDisplay() {
    setState(() {
      displayIn3s = !displayIn3s;
      sharedPreferences.setBool("displayIn3s", displayIn3s);
    });
  }

  Widget? tableIn3s;
  Widget? tableIn6s;

  DisplayTableCell itemCell(Product item, FixedProductReport? itemReport) {
    return DisplayTableCell(
      item.name,
      onTap: () => openItemReport(context, item, widget.summeryDoc),
    );
  }

  Widget get getTableIn3s {
    final rows = <List<DisplayTableCell>>[];
    const emptyCell = DisplayTableCell.empty();
    for (var item in widget.productDoc.allProducts) {
      final itemReport = widget.productReports[item.id];
      rows.add([
        itemCell(item, itemReport),
        DisplayTableCell("Retail"),
        DisplayTableCell(itemReport?.totalRetail.negateText ?? "--"),
      ]);
      rows.add([
        emptyCell,
        DisplayTableCell("WholeSell"),
        DisplayTableCell(itemReport?.totalWholeSell.negateText ?? "--"),
      ]);
      rows.add([
        emptyCell,
        DisplayTableCell("InternalChnages"),
        DisplayTableCell(itemReport?.totalStockChanges.text ?? "--"),
      ]);
      rows.add([
        emptyCell,
        DisplayTableCell("Stock Send"),
        DisplayTableCell(itemReport?.totalStockSend.text ?? "--"),
      ]);
      rows.add([
        emptyCell,
        DisplayTableCell("Stock Recive"),
        DisplayTableCell(itemReport?.totalStockRecive.text ?? "--"),
      ]);
      rows.add([
        emptyCell,
        emptyCell,
        emptyCell,
      ]);
    }
    return ListView(
      children: [
        DisplayTable(
          titleNames: const ["Name", "Type", "Quntity"],
          data2D: rows,
          colorRow: Iterable.generate(
            rows.length,
            (i) => i % 6 == 0 ? Colors.blueAccent : null,
          ),
        ).build(context)
      ],
    );
  }

  Widget get getTableIn6s {
    final rows = <List<DisplayTableCell>>[];
    for (var item in widget.productDoc.allProducts) {
      final itemReport = widget.productReports[item.id];
      rows.add([
        itemCell(item, itemReport),
        DisplayTableCell(itemReport?.totalRetail.negateText ?? "--"),
        DisplayTableCell(itemReport?.totalWholeSell.negateText ?? "--"),
        DisplayTableCell(itemReport?.totalStockChanges.text ?? "--"),
        DisplayTableCell(itemReport?.totalStockSend.text ?? "--"),
        DisplayTableCell(itemReport?.totalStockRecive.text ?? "--"),
      ]);
    }
    return ListView(
      children: [
        DisplayTable(
          titleNames: const [
            "Name",
            "Retail",
            "Whole",
            "Int.",
            "Send",
            "Recive"
          ],
          data2D: rows,
        ).build(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final table = displayIn3s
        ? (tableIn3s ??= getTableIn3s)
        : (tableIn6s ??= getTableIn6s);
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(isTablet ? "Items Table" : "Overview"),
        actions: [
          TextButton(
            onPressed: toggelDisplay,
            child: const IconT3(
              Icons.table_chart_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(8.0), child: table),
    );
  }
}

void openItemReport(
  BuildContext context,
  Product item,
  SummeryDoc summeryDoc,
) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: appBarTitle("Item Report")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FullItemReport(product: item, summeryDoc: summeryDoc),
        ),
      );
    }),
  );
}

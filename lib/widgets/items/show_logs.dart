import 'package:flutter/material.dart';
import 'package:vdp/documents/logs.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/items/display_item.dart';

class ShowLogs extends StatelessWidget {
  const ShowLogs({Key? key, required this.log}) : super(key: key);
  final Log log;

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

  @override
  Widget build(BuildContext context) {
    final time = log.createdAt.split("T");
    final map = log.remainingStock;
    return ListView(
      children: [
        badge,
        const SizedBox(height: 20),
        title,
        const SizedBox(height: 20),
        infoCell("Created By", getUserInfo(log.createdBy)?.name),
        const SizedBox(height: 10),
        infoCell("Date", time[0]),
        const SizedBox(height: 10),
        infoCell("Time", time[1].substring(0, 8)),
        const SizedBox(height: 100),
        SizedBox(
          width: double.infinity,
          child: log.oldProduct == null
              ? ProductTable(product: log.product)
              : _CompareProductTable(
                  newProduct: log.product,
                  oldProduct: log.oldProduct as Product,
                ),
        ),
        if (map != null && map.isNotEmpty) ...[
          const SizedBox(height: 50),
          _RemainingStockTable(remainingStock: map)
        ]
      ],
    );
  }

  Center get title {
    return Center(
      child: Text(
        log.oldProduct == null
            ? log.isCreateItemLog
                ? "Item Created"
                : "Item Removed"
            : "Item Updated",
        style: const TextStyle(fontSize: 50),
      ),
    );
  }

  Container get badge {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: log.oldProduct == null
            ? log.isCreateItemLog
                ? Colors.green
                : Colors.red
            : Colors.blue,
      ),
      height: 15,
    );
  }
}

class _RemainingStockTable extends StatelessWidget {
  const _RemainingStockTable({
    Key? key,
    required this.remainingStock,
  }) : super(key: key);
  final Map<String, FixedNumber> remainingStock;

  @override
  Widget build(BuildContext context) {
    final rows = <DataRow>[];
    for (var stockEntry in remainingStock.entries) {
      rows.add(DataRow(cells: [
        DataCell(Text(getStockInfo(stockEntry.key)?.name ?? "--*--")),
        DataCell(Text(stockEntry.value.text)),
      ]));
    }
    return DataTable(
      headingTextStyle: const TextStyle(fontSize: 40),
      headingRowColor: MaterialStateProperty.resolveWith((_) => Colors.red),
      dataTextStyle: const TextStyle(fontSize: 30, color: Colors.black),
      columns: const [
        DataColumn(label: Text("Stock Unit")),
        DataColumn(label: Text("Quntity On Remove")),
      ],
      rows: rows,
    );
  }
}

class _CompareProductTable extends StatelessWidget {
  const _CompareProductTable({
    Key? key,
    required this.oldProduct,
    required this.newProduct,
  }) : super(key: key);
  final Product oldProduct;
  final Product newProduct;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: const TextStyle(fontSize: 40),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.purple),
      dataTextStyle: const TextStyle(fontSize: 30, color: Colors.black),
      columns: const [
        DataColumn(label: Text("Label")),
        DataColumn(label: Text("Old Value")),
        DataColumn(label: Text("New Value")),
      ],
      rows: [
        DataRow(
          cells: [
            const DataCell(Text("Name")),
            DataCell(Text(oldProduct.name)),
            DataCell(Text(newProduct.name)),
          ],
          color: oldProduct.name == newProduct.name
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.green),
        ),
        DataRow(
          cells: [
            const DataCell(Text("Code")),
            DataCell(Text(oldProduct.code ?? "--*--")),
            DataCell(Text(newProduct.code ?? "--*--")),
          ],
          color: oldProduct.code == newProduct.code
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.green),
        ),
        DataRow(
          cells: [
            const DataCell(Text("Collection")),
            DataCell(Text(oldProduct.collectionName ?? "--*--")),
            DataCell(Text(newProduct.collectionName ?? "--*--")),
          ],
          color: oldProduct.collectionName == newProduct.collectionName
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.green),
        ),
        DataRow(
          cells: [
            const DataCell(Text("Rate1")),
            DataCell(Text(rs_ + oldProduct.rate1.toString())),
            DataCell(Text(rs_ + newProduct.rate1.toString())),
          ],
          color: oldProduct.rate1 == newProduct.rate1
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
        DataRow(
          cells: [
            const DataCell(Text("Rate2")),
            DataCell(Text(rs_ + oldProduct.rate2.toString())),
            DataCell(Text(rs_ + newProduct.rate2.toString())),
          ],
          color: oldProduct.rate2 == newProduct.rate2
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
        DataRow(
          cells: [
            const DataCell(Text("cgst")),
            DataCell(Text(oldProduct.cgst.toString() + " %")),
            DataCell(Text(newProduct.cgst.toString() + " %")),
          ],
          color: oldProduct.cgst == newProduct.cgst
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
        DataRow(
          cells: [
            const DataCell(Text("sgst")),
            DataCell(Text(oldProduct.sgst.toString() + " %")),
            DataCell(Text(newProduct.sgst.toString() + " %")),
          ],
          color: oldProduct.sgst == newProduct.sgst
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdp/documents/logs.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/items/display_item.dart';

class ShowLogs extends StatelessWidget {
  const ShowLogs({Key? key, required this.log}) : super(key: key);
  final Log log;

  @override
  Widget build(BuildContext context) {
    final time = log.createdAt.split("T");
    final map = log.remainingStock;
    return BuildPageBody(
      wrapScaffold: true,
      title: log.oldProduct == null
          ? log.isCreateItemLog
              ? "Item Created"
              : "Item Removed"
          : "Item Updated",
      badge: badge,
      children: [
        InfoCell("Created By", getUserInfo(log.createdBy)?.name),
        InfoCell("Date", time[0]),
        InfoCell("Time", time[1].substring(0, 8)),
      ],
      trailing: [
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
        DataCell(P3(getStockInfo(stockEntry.key)?.name ?? "--*--")),
        DataCell(P3(stockEntry.value.text)),
      ]));
    }
    return DataTable(
      columns: const [
        DataColumn(label: T2("Stock Unit", color: Colors.red)),
        DataColumn(label: T2("Quntity On Remove", color: Colors.red)),
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
      columns: const [
        DataColumn(
            label: T2(
          "Label",
          color: Colors.purple,
        )),
        DataColumn(
            label: T2(
          "Old Value",
          color: Colors.purple,
        )),
        DataColumn(
            label: T2(
          "New Value",
          color: Colors.purple,
        )),
      ],
      rows: [
        DataRow(
          cells: [
            const DataCell(P3("Name")),
            DataCell(P3(oldProduct.name)),
            DataCell(P3(newProduct.name)),
          ],
          color: oldProduct.name == newProduct.name
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.green),
        ),
        DataRow(
          cells: [
            const DataCell(P3("Code")),
            DataCell(P3(oldProduct.code ?? "--*--")),
            DataCell(P3(newProduct.code ?? "--*--")),
          ],
          color: oldProduct.code == newProduct.code
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.green),
        ),
        DataRow(
          cells: [
            const DataCell(P3("Collection")),
            DataCell(P3(oldProduct.collectionName ?? "--*--")),
            DataCell(P3(newProduct.collectionName ?? "--*--")),
          ],
          color: oldProduct.collectionName == newProduct.collectionName
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.green),
        ),
        DataRow(
          cells: [
            const DataCell(P3("Rate1")),
            DataCell(P3(rs_ + oldProduct.rate1.toString())),
            DataCell(P3(rs_ + newProduct.rate1.toString())),
          ],
          color: oldProduct.rate1 == newProduct.rate1
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
        DataRow(
          cells: [
            const DataCell(P3("Rate2")),
            DataCell(P3(rs_ + oldProduct.rate2.toString())),
            DataCell(P3(rs_ + newProduct.rate2.toString())),
          ],
          color: oldProduct.rate2 == newProduct.rate2
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
        DataRow(
          cells: [
            const DataCell(P3("cgst")),
            DataCell(P3(oldProduct.cgst.toString() + " %")),
            DataCell(P3(newProduct.cgst.toString() + " %")),
          ],
          color: oldProduct.cgst == newProduct.cgst
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
        DataRow(
          cells: [
            const DataCell(P3("sgst")),
            DataCell(P3(oldProduct.sgst.toString() + " %")),
            DataCell(P3(newProduct.sgst.toString() + " %")),
          ],
          color: oldProduct.sgst == newProduct.sgst
              ? null
              : MaterialStateProperty.resolveWith((states) => Colors.pink),
        ),
      ],
    );
  }
}

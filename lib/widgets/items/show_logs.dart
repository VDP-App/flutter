import 'package:flutter/material.dart';
import 'package:vdp/documents/logs.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';
import 'package:vdp/utils/display_table.dart';
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
      topic: log.oldProduct == null
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
    return DisplayTable.fromString(
      titleNames: const ["Unit", "Q"],
      data2D: remainingStock.entries.map((stockEntry) => [
            getStockInfo(stockEntry.key)?.name ?? "--*--",
            stockEntry.value.text,
          ]),
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
    return DisplayTable.fromString(
      titleNames: const ["Label", "Old", "New"],
      colorRow: [
        oldProduct.name == newProduct.name ? null : Colors.green,
        oldProduct.code == newProduct.code ? null : Colors.green,
        oldProduct.collectionName == newProduct.collectionName
            ? null
            : Colors.green,
        oldProduct.rate1 == newProduct.rate1 ? null : Colors.red,
        oldProduct.rate2 == newProduct.rate2 ? null : Colors.red,
        oldProduct.cgst == newProduct.cgst ? null : Colors.red,
        oldProduct.sgst == newProduct.sgst ? null : Colors.red,
      ],
      data2D: [
        ["Name", oldProduct.name, newProduct.name],
        ["Code", oldProduct.code ?? "--*--", newProduct.code ?? "--*--"],
        [
          "Collection",
          oldProduct.collectionName ?? "--*--",
          newProduct.collectionName ?? "--*--"
        ],
        [
          "Rate1",
          rs_ + oldProduct.rate1.toString(),
          rs_ + newProduct.rate1.toString()
        ],
        [
          "Rate2",
          rs_ + oldProduct.rate2.toString(),
          rs_ + newProduct.rate2.toString()
        ],
        [
          "cgst",
          oldProduct.cgst.toString() + " %",
          newProduct.cgst.toString() + " %"
        ],
        [
          "sgst",
          oldProduct.sgst.toString() + " %",
          newProduct.sgst.toString() + " %"
        ],
      ],
    );
  }
}

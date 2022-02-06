import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: T2("Label", color: Colors.purple)),
        DataColumn(label: T2("Value", color: Colors.purple)),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(P3("Name")),
          DataCell(P3(product.name)),
        ]),
        DataRow(cells: [
          const DataCell(P3("Code")),
          DataCell(P3(product.code ?? "--*--")),
        ]),
        DataRow(cells: [
          const DataCell(P3("Collection")),
          DataCell(P3(product.collectionName ?? "--*--")),
        ]),
        DataRow(cells: [
          const DataCell(P3("Rate1")),
          DataCell(P3(rs_ + product.rate1.toString())),
        ]),
        DataRow(cells: [
          const DataCell(P3("Rate2")),
          DataCell(P3(rs_ + product.rate2.toString())),
        ]),
        DataRow(cells: [
          const DataCell(P3("cgst")),
          DataCell(P3(product.cgst.toString() + " %")),
        ]),
        DataRow(cells: [
          const DataCell(P3("sgst")),
          DataCell(P3(product.sgst.toString() + " %")),
        ]),
      ],
    );
  }
}

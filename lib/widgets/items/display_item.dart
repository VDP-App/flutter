import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/utils/loading.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: const TextStyle(fontSize: 40),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.purple),
      dataTextStyle: const TextStyle(fontSize: 30, color: Colors.black),
      columns: const [
        DataColumn(label: Text("Label")),
        DataColumn(label: Text("Value")),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text("Name")),
          DataCell(Text(product.name)),
        ]),
        DataRow(cells: [
          const DataCell(Text("Code")),
          DataCell(Text(product.code ?? "--*--")),
        ]),
        DataRow(cells: [
          const DataCell(Text("Collection")),
          DataCell(Text(product.collectionName ?? "--*--")),
        ]),
        DataRow(cells: [
          const DataCell(Text("Rate1")),
          DataCell(Text(rs_ + product.rate1.toString())),
        ]),
        DataRow(cells: [
          const DataCell(Text("Rate2")),
          DataCell(Text(rs_ + product.rate2.toString())),
        ]),
        DataRow(cells: [
          const DataCell(Text("cgst")),
          DataCell(Text(product.cgst.toString() + " %")),
        ]),
        DataRow(cells: [
          const DataCell(Text("sgst")),
          DataCell(Text(product.sgst.toString() + " %")),
        ]),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/loading.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return DisplayTable.fromString(
      titleNames: const ["Label", "Value"],
      data2D: [
        ["Name", product.name],
        ["Code", product.code ?? "--*--"],
        ["Collection", product.collectionName ?? "--*--"],
        ["Rate1", rs_ + product.rate1.toString()],
        ["Rate2", rs_ + product.rate2.toString()],
        ["cgst", product.cgst.toString() + " %"],
        ["sgst", product.sgst.toString() + " %"],
      ],
    );
  }
}

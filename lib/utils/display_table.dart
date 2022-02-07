import 'package:flutter/material.dart';
import 'package:vdp/utils/typography.dart';

class DisplayTableCell extends DataCell {
  DisplayTableCell(String text, {Color? color, FontWeight? fontWeight})
      : super(P3(
          text,
          color: color,
          fontWeight: fontWeight,
        ));
}

class DisplayTable extends StatelessWidget {
  final Iterable<String> titleNames;
  final Iterable<Iterable<DisplayTableCell>> data2D;

  const DisplayTable({
    Key? key,
    required this.titleNames,
    required this.data2D,
  }) : super(key: key);

  factory DisplayTable.fromString({
    Key? key,
    required Iterable<String> titleNames,
    required Iterable<Iterable<String>> data2D,
  }) =>
      DisplayTable(
        titleNames: titleNames,
        data2D: data2D.map((x) => x.map((y) => DisplayTableCell(y))),
      );

  @override
  Widget build(BuildContext context) {
    final columns1 = <DataColumn>[];
    final columns2 = <DataColumn>[];
    var isFirst = true;
    for (var column in titleNames) {
      if (isFirst) {
        columns1.add(DataColumn(
          label: T2(column, color: Colors.purple),
        ));
        isFirst = false;
      } else {
        columns2.add(DataColumn(
          label: T2(column, color: Colors.purple),
        ));
      }
    }
    final rows1 = <DataRow>[];
    final rows2 = <DataRow>[];
    for (var row in data2D) {
      var isFirst = true;
      var cells = <DisplayTableCell>[];
      for (var cell in row) {
        if (isFirst) {
          rows1.add(DataRow(cells: [cell]));
          isFirst = false;
        } else {
          cells.add(cell);
        }
      }
      rows2.add(DataRow(cells: cells));
    }
    return Row(
      children: [
        DataTable(
          columns: columns1,
          rows: rows1,
          border: TableBorder.all(width: .2),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              // dividerThickness: 1,
              columns: columns2,
              rows: rows2,
              border: TableBorder.all(borderRadius: BorderRadius.circular(5)),
            ),
          ),
        )
      ],
    );
  }
}

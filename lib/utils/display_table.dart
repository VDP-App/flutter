import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/typography.dart';

class DisplayTableCell extends DataCell {
  final String text;
  DisplayTableCell(
    this.text, {
    Color? color,
    FontWeight? fontWeight,
    void Function()? onTap,
  }) : super(
          P3(text, color: color, fontWeight: fontWeight),
          onTap: onTap,
        );
  const DisplayTableCell.empty()
      : text = "",
        super(const SizedBox());
}

class DisplayTable extends StatelessWidget {
  final Iterable<String> titleNames;
  final Iterable<Iterable<DisplayTableCell>> data2D;
  final Iterable<Color?>? colorRow;
  const DisplayTable({
    Key? key,
    required this.titleNames,
    required this.data2D,
    this.colorRow,
  }) : super(key: key);

  factory DisplayTable.fromString({
    Key? key,
    required Iterable<String> titleNames,
    required Iterable<Iterable<String>> data2D,
    Iterable<Color?>? colorRow,
  }) =>
      DisplayTable(
        titleNames: titleNames,
        data2D: data2D.map((x) => x.map((y) => DisplayTableCell(y))),
        colorRow: colorRow,
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
    final _colorRow = colorRow;
    if (_colorRow == null) {
      for (var i = 0; i < data2D.length; i++) {
        var row = data2D.elementAt(i);
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
    } else {
      for (var i = 0; i < data2D.length; i++) {
        var row = data2D.elementAt(i);
        var _color = _colorRow.elementAt(i);
        var isFirst = true;
        var cells = <DisplayTableCell>[];
        for (var cell in row) {
          if (isFirst) {
            rows1.add(
              _color == null
                  ? DataRow(cells: [cell])
                  : DataRow(
                      cells: [
                        DisplayTableCell(
                          cell.text,
                          color: Colors.white,
                          onTap: cell.onTap,
                        )
                      ],
                      color: MaterialStateProperty.resolveWith((_) => _color),
                    ),
            );
            isFirst = false;
          } else {
            cells.add(cell);
          }
        }
        rows2.add(DataRow(cells: cells));
      }
    }
    return Row(
      children: [
        DataTable(
          columns: columns1,
          rows: rows1,
          border: TableBorder.all(width: isTablet ? 1 : .2),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
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

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

final idWidth = isTablet ? 325.0 : 200.0;
final width4char = isTablet ? 100.0 : 80.0;
final width5char = isTablet ? 150.0 : 100.0;
final width6char = isTablet ? 150.0 : 110.0;
final width8char = isTablet ? 200.0 : 120.0;

class TablePageCell {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  const TablePageCell(this.text, {this.color, this.fontWeight});
}

class TablePageID {
  final String text;
  final Color? bgColor;
  final FontWeight? fontWeight;
  const TablePageID(this.text, {this.bgColor, this.fontWeight});
}

class TablePage extends StatelessWidget {
  final String pageTitle;
  final List<String> titleNames;
  final TablePageID Function(int i) getID;
  final List<TablePageCell> Function(int i) getRow;
  final int length;
  final double idWidth;
  final Iterable<double> rowCellWidth;
  final void Function(int i)? onTapRow;
  const TablePage({
    Key? key,
    required this.pageTitle,
    required this.titleNames,
    required this.getID,
    required this.getRow,
    required this.length,
    required this.rowCellWidth,
    required this.idWidth,
    this.onTapRow,
  }) : super(key: key);

  factory TablePage.fromString({
    Key? key,
    required String pageTitle,
    required List<String> titleNames,
    required Iterable<Iterable<String>> data2D,
    Iterable<Color?>? colorRow,
    required double idWidth,
    required Iterable<double> rowCellWidth,
    void Function(int i)? onTapRow,
  }) {
    return TablePage(
      pageTitle: pageTitle,
      idWidth: idWidth,
      rowCellWidth: rowCellWidth,
      titleNames: titleNames,
      onTapRow: onTapRow,
      getID: colorRow == null
          ? (i) => TablePageID(data2D.elementAt(i).first)
          : (i) => TablePageID(
                data2D.elementAt(i).first,
                bgColor: colorRow.elementAt(i),
              ),
      getRow: (i) {
        final row = <TablePageCell>[];
        final data = data2D.elementAt(i);
        for (var i = 1; i < data.length; i++) {
          row.add(TablePageCell(data.elementAt(i)));
        }
        return row;
      },
      length: data2D.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appBarTitle(pageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: length == 0
            ? const NoData(text: "No Data To Show")
            : HorizontalDataTable(
                elevation: 2.5,
                leftHandSideColumnWidth: idWidth,
                rightHandSideColumnWidth: rowCellWidth.reduce((v, e) => v + e) +
                    (onTapRow == null ? 0 : 16),
                isFixedHeader: true,
                headerWidgets: _getTitleWidget,
                leftSideItemBuilder: _makeRowBuilder(_stickyColumnCell),
                rightSideItemBuilder: _makeRowBuilder(_getRow),
                itemCount: length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
              ),
      ),
    );
  }

  Widget Function(BuildContext context, int i) _makeRowBuilder(
      Widget Function(int i) builder) {
    if (onTapRow == null) {
      return (_, i) {
        return builder(i);
      };
    }
    return (_, i) {
      return TextButton(
        onPressed: () => onTapRow!(i),
        child: builder(i),
      );
    };
  }

  Widget _getRow(int i) {
    final rowData = getRow(i);
    final row = <Widget>[];
    for (var i = 0; i < rowData.length; i++) {
      final cell = rowData[i];
      row.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
        width: rowCellWidth.elementAt(i),
        height: 70,
        child: P3(
          cell.text,
          fontWeight: cell.fontWeight,
          color: cell.color ?? Colors.black,
        ),
      ));
    }
    return Row(children: row);
  }

  Widget _stickyColumnCell(int i) {
    final id = getID(i);
    return Container(
      width: idWidth,
      height: 70,
      child: P3(id.text,
          fontWeight: id.fontWeight,
          color: id.bgColor == null ? Colors.black : Colors.white),
      color: id.bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
    );
  }

  List<Widget> get _getTitleWidget {
    final header = [
      Container(
        color: Colors.deepPurple,
        width: idWidth,
        child: T2(titleNames.first, color: Colors.white),
        padding: const EdgeInsets.all(7),
      ),
    ];
    for (var i = 1; i < titleNames.length; i++) {
      header.add(
        Container(
          color: Colors.deepPurpleAccent,
          width: rowCellWidth.elementAt(i - 1),
          child: T2(titleNames.elementAt(i), color: Colors.white),
          padding: const EdgeInsets.all(7),
          margin: onTapRow == null ? null : const EdgeInsets.only(left: 4),
        ),
      );
    }
    return header;
  }
}

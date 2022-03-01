import 'dart:math';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

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

class TablePage extends StatefulWidget {
  final String pageTitle;
  final List<String> titleNames;
  final TablePageID Function(int i) getID;
  final List<TablePageCell> Function(int i) getRow;
  final int length;
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
    this.onTapRow,
  }) : super(key: key);

  factory TablePage.fromString({
    Key? key,
    required String pageTitle,
    required List<String> titleNames,
    required Iterable<Iterable<String>> data2D,
    Iterable<Color?>? colorRow,
    required Iterable<double> rowCellWidth,
    void Function(int i)? onTapRow,
  }) {
    return TablePage(
      pageTitle: pageTitle,
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
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  var idWidth =
      sharedPreferences.getDouble("idWidth") ?? (isTablet ? 325.0 : 225.0);

  void incWidth() {
    if (isTablet) {
      if (idWidth >= 360) return;
    } else {
      if (idWidth >= 260) return;
    }
    setState(() {
      idWidth += 5;
      sharedPreferences.setDouble("idWidth", idWidth);
    });
  }

  void decWidth() {
    if (isTablet) {
      if (idWidth <= 300) return;
    } else {
      if (idWidth <= 200) return;
    }
    setState(() {
      idWidth -= 5;
      sharedPreferences.setDouble("idWidth", idWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rigthHandScreenWidth =
        MediaQuery.of(context).size.width - idWidth - 16;
    final rigthHandWidth = widget.rowCellWidth.reduce((v, e) => v + e) +
        (widget.onTapRow == null ? 0 : 16);
    return Scaffold(
      appBar: AppBar(title: appBarTitle(widget.pageTitle, true), actions: [
        TextButton(
          onPressed: decWidth,
          child: const Icon(
            Icons.exposure_minus_1_rounded,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: incWidth,
          child: const Icon(
            Icons.exposure_plus_1_rounded,
            color: Colors.white,
          ),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.length == 0
            ? const NoData(text: "No Data To Show")
            : HorizontalDataTable(
                elevation: 2.5,
                leftHandSideColumnWidth: idWidth,
                rightHandSideColumnWidth:
                    max(rigthHandWidth, rigthHandScreenWidth),
                isFixedHeader: true,
                headerWidgets: _getTitleWidget,
                leftSideItemBuilder: _makeRowBuilder(_stickyColumnCell),
                rightSideItemBuilder: _makeRowBuilder(_getRow),
                itemCount: widget.length,
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
    if (widget.onTapRow == null) {
      return (_, i) {
        return builder(i);
      };
    }
    return (_, i) {
      return TextButton(
        onPressed: () => widget.onTapRow!(i),
        child: builder(i),
      );
    };
  }

  Widget _getRow(int i) {
    final rowData = widget.getRow(i);
    final row = <Widget>[];
    for (var i = 0; i < rowData.length; i++) {
      final cell = rowData[i];
      row.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
        width: widget.rowCellWidth.elementAt(i),
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
    final id = widget.getID(i);
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
        child: T2(widget.titleNames.first, color: Colors.white),
        padding: const EdgeInsets.all(7),
      ),
    ];
    for (var i = 1; i < widget.titleNames.length; i++) {
      header.add(
        Container(
          color: Colors.deepPurpleAccent,
          width: widget.rowCellWidth.elementAt(i - 1),
          child: T2(widget.titleNames.elementAt(i), color: Colors.white),
          padding: const EdgeInsets.all(7),
          margin:
              widget.onTapRow == null ? null : const EdgeInsets.only(left: 4),
        ),
      );
    }
    return header;
  }
}

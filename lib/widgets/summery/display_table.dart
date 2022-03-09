import 'dart:math';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

final _widthColumnID = isTablet ? 260.0 : 200.0;
final _widthColumn = isTablet ? 150.0 : 100.0;

bool _isColumnAvalable(String id, int index) =>
    sharedPreferences.getBool("column-$id-$index") ?? true;
Future<void> _setColumnAvalable(String id, int index, bool val) =>
    sharedPreferences.setBool("column-$id-$index", val);

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
  final Iterable<String> titleNames;
  final Iterable<TablePageCell> Function(int i) getRow;
  final String pageTitle;
  final String id;
  final TablePageID Function(int i) getID;
  final int length;
  final void Function(int i)? onTapRow;
  const TablePage({
    Key? key,
    required this.id,
    required this.pageTitle,
    required this.titleNames,
    required this.getID,
    required this.getRow,
    required this.length,
    this.onTapRow,
  }) : super(key: key);

  factory TablePage.fromString({
    Key? key,
    required String pageTitle,
    required List<String> titleNames,
    required Iterable<Iterable<String>> data2D,
    Iterable<Color?>? colorRow,
    void Function(int i)? onTapRow,
    required String id,
  }) {
    return TablePage(
      id: id,
      pageTitle: pageTitle,
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
  var titleNames = <String>[];
  var getRow = ((int i) => <TablePageCell>[]);
  var rowCellWidth = <double>[];
  var mapColumn = <String, int>{};
  var editMode = false;

  @override
  void initState() {
    setState(() {
      updateColumns();
    });
    super.initState();
  }

  void updateColumns() {
    titleNames = [widget.titleNames.first];
    rowCellWidth = [];
    mapColumn = {};
    final avalableColumn = List.generate(widget.titleNames.length - 1, (index) {
      var a = _isColumnAvalable(widget.id, index);
      if (a) {
        final name = widget.titleNames.elementAt(index + 1);
        titleNames.add(name);
        mapColumn[name] = rowCellWidth.length;
        rowCellWidth.add(
            sharedPreferences.getDouble("columnWidth-${widget.id}-$name") ??
                _widthColumn);
      }
      return a;
    });
    getRow = (index) {
      final val = widget.getRow(index);
      final _val = <TablePageCell>[];
      for (var i = 0; i < avalableColumn.length; i++) {
        if (avalableColumn[i]) _val.add(val.elementAt(i));
      }
      return _val;
    };
  }

  var idWidth =
      sharedPreferences.getDouble("idWidth") ?? (isTablet ? 325.0 : 225.0);

  void incIDWidth(double i) {
    setState(() {
      idWidth += i;
      sharedPreferences.setDouble("idWidth", idWidth);
      if (idWidth > _widthColumnID + 100) {
        idWidth = _widthColumnID + 100;
      } else if (idWidth < _widthColumnID) {
        idWidth = _widthColumnID;
      }
    });
  }

  void incColumnWidth(double i, String name) {
    final index = mapColumn[name];
    if (index == null) return;
    setState(() {
      rowCellWidth[index] += i;
      sharedPreferences.setDouble(
          "columnWidth-${widget.id}-$name", rowCellWidth[index]);
      if (rowCellWidth[index] > _widthColumn + 75) {
        rowCellWidth[index] = _widthColumn + 75;
      } else if (rowCellWidth[index] < _widthColumn) {
        rowCellWidth[index] = _widthColumn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rigthHandScreenWidth =
        MediaQuery.of(context).size.width - idWidth - 16;
    final rigthHandWidth = rowCellWidth.reduce((v, e) => v + e) +
        (widget.onTapRow == null ? 0 : 16);
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(widget.pageTitle, short: true),
        actions: editMode
            ? <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      editMode = false;
                    });
                  },
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                PopupMenuButton(
                  itemBuilder: (context) {
                    final names = widget.titleNames;
                    final list = <PopupMenuItem>[];
                    for (var i = 0; i < widget.titleNames.length - 1; i++) {
                      list.add(PopupMenuItem(
                        child: SelectColumn(
                            columnName: names.elementAt(i + 1),
                            id: widget.id,
                            index: i,
                            onSelect: () {
                              setState(() {
                                updateColumns();
                              });
                            }),
                      ));
                    }
                    return list;
                  },
                )
              ]
            : <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      editMode = true;
                    });
                  },
                  child: const Icon(Icons.settings, color: Colors.white),
                ),
              ],
      ),
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
    Widget Function(int i) builder,
  ) {
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
    final rowData = getRow(i);
    final row = <Widget>[];
    for (var i = 0; i < rowData.length; i++) {
      final cell = rowData.elementAt(i);
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            T2(titleNames.first, color: Colors.white),
            if (editMode)
              GestureDetector(
                onHorizontalDragUpdate: (details) =>
                    incIDWidth(details.delta.dx),
                child: const IconT3(
                  Icons.swap_horizontal_circle_rounded,
                  color: Colors.redAccent,
                ),
              ),
          ],
        ),
        padding: const EdgeInsets.all(7),
      ),
    ];
    for (var i = 1; i < titleNames.length; i++) {
      final name = titleNames.elementAt(i);
      header.add(
        Container(
          color: Colors.deepPurpleAccent,
          width: rowCellWidth.elementAt(i - 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              T2(
                editMode && name.length > 3 ? name.substring(0, 3) : name,
                color: Colors.white,
              ),
              if (editMode)
                GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      incColumnWidth(details.delta.dx, name),
                  child: const IconT3(
                    Icons.swap_horizontal_circle_rounded,
                    color: Colors.redAccent,
                  ),
                ),
            ],
          ),
          padding: const EdgeInsets.all(7),
          margin:
              widget.onTapRow == null ? null : const EdgeInsets.only(left: 4),
        ),
      );
    }
    return header;
  }
}

class SelectColumn extends StatefulWidget {
  const SelectColumn({
    Key? key,
    required this.columnName,
    required this.id,
    required this.index,
    required this.onSelect,
  }) : super(key: key);
  final String columnName;
  final int index;
  final String id;
  final void Function() onSelect;
  @override
  State<SelectColumn> createState() => _SelectColumnState();
}

class _SelectColumnState extends State<SelectColumn> {
  var isSelected = true;

  @override
  void initState() {
    setState(() {
      isSelected = _isColumnAvalable(widget.id, widget.index);
    });
    super.initState();
  }

  void onTap(bool? val) {
    setState(() {
      isSelected = val ?? !isSelected;
      _setColumnAvalable(widget.id, widget.index, isSelected)
          .whenComplete(() => widget.onSelect());
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTap(null),
      child: Row(
        children: [
          Checkbox(value: isSelected, onChanged: onTap),
          Text(widget.columnName),
        ],
      ),
    );
  }
}

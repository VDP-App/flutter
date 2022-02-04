import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/stocking.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'custom/custom.dart';

enum Focuses { itemNum, setQuntity, addQuntity }

class StockDisplay<T extends Stocking> extends DisplayClass {
  const StockDisplay({Key? key}) : super(key: key);

  List<List<DisplayCell>> order({
    required Focuses focusedAt,
    required String itemNum,
    required String name,
    required String currentQuntity,
    required String addedQuntity,
    required String setQuntity,
    required void Function() selectItem,
    required void Function() showStockChanges,
  }) {
    return [
      itemLine(
        active: focusedAt == Focuses.itemNum,
        itemNum: itemNum,
        selectItem: selectItem,
        showOrders: showStockChanges,
      ),
      [DisplayCell(lable: "Name", value: name)],
      [DisplayCell(lable: "Current", value: currentQuntity)],
      [
        DisplayCell(
          lable: T == TransferStock
              ? "Send"
              : focusedAt == Focuses.addQuntity
                  ? "Add"
                  : "Change",
          value: addedQuntity,
          active: focusedAt == Focuses.addQuntity,
        ),
        DisplayCell(
          lable: focusedAt == Focuses.setQuntity ? "Set" : "Final",
          value: setQuntity,
          active: focusedAt == Focuses.setQuntity,
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stocking = Provider.of<T>(context);
    if (stocking.loading) return loadingWigit;
    return DisplayBuilder(
      cellsIn2d: order(
        focusedAt: stocking.focusedAt,
        itemNum: stocking.itemNum,
        name: stocking.name,
        addedQuntity: stocking.addedQuntity,
        currentQuntity: stocking.currentQuntity,
        setQuntity: stocking.setQuntity,
        selectItem: stocking.openItemSelector,
        showStockChanges: stocking.openStockChanges,
      ),
    );
  }
}

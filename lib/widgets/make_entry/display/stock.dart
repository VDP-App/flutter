import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/stocking.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'custom/custom.dart';

enum Focuses { itemNum, setQuntity, addQuntity }

class StockDisplay<T extends Stocking> extends DisplayClass {
  const StockDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stocking = Provider.of<T>(context);
    if (stocking.loading) return loadingWigit;

    return DisplayBuilder(
      cellsIn2d: [
        itemLine(
          resetItemCode: stocking.resetItemCode,
          length: stocking.length,
          active: stocking.focusedAt == Focuses.itemNum,
          itemNum: stocking.itemNum,
          selectItem: stocking.openItemSelector,
          showOrders: stocking.openStockChanges,
        ),
        [DisplayCell(lable: "Name", value: stocking.name)],
        [DisplayCell(lable: "Current", value: stocking.currentQuntity)],
        [
          DisplayCell(
            lable: T == TransferStock
                ? "Send"
                : stocking.focusedAt == Focuses.addQuntity
                    ? "Add"
                    : "Change",
            value: stocking.addedQuntity,
            active: stocking.focusedAt == Focuses.addQuntity,
          ),
          DisplayCell(
            lable: stocking.focusedAt == Focuses.setQuntity ? "Set" : "Final",
            value: stocking.setQuntity,
            active: stocking.focusedAt == Focuses.setQuntity,
          ),
        ],
      ],
    );
  }
}

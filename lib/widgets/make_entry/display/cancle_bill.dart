import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/cancle_bill.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'custom/custom.dart';

enum Focuses { itemNum, quntity, price, transfer }

class CancleBillDisplay extends DisplayClass {
  const CancleBillDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cancleBill = Provider.of<CancleBill>(context);
    if (cancleBill.loading) return loadingWigit;
    return DisplayBuilder(
      cellsIn2d: [
        [
          DisplayCell(
            lable: "BillNum",
            value: cancleBill.billNum,
            active: true,
            onClick: cancleBill.clear,
          ),
        ],
        const [],
        const [],
        const [],
      ],
    );
  }
}

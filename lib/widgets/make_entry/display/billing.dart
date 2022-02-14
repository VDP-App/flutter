import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/billing.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'custom/custom.dart';

enum Focuses { itemNum, quntity, price, transfer }

class BillingDisplay<T extends Billing> extends DisplayClass {
  const BillingDisplay({Key? key}) : super(key: key);

  List<List<DisplayCell>> order(Billing billing) {
    return [
      itemLine(
        resetItemCode: billing.resetItemCode,
        length: billing.length,
        active: billing.focusedAt == Focuses.itemNum,
        itemNum: billing.itemCode,
        selectItem: billing.openItemSelector,
        showOrders: billing.openOrders,
      ),
      [DisplayCell(lable: "Name", value: billing.name)],
      [
        DisplayCell(
          lable: "Q",
          value: billing.quntity,
          active: billing.focusedAt == Focuses.quntity,
          onClick: billing.selectQuntity,
        ),
        DisplayCell(
          lable: "A",
          value: billing.price,
          active: billing.focusedAt == Focuses.price,
          onClick: billing.selectAmount,
        ),
      ],
      [
        DisplayCell(lable: "Rate", value: billing.rate),
        DisplayCell(lable: "Total", value: billing.total),
      ],
    ];
  }

  List<List<DisplayCell>> summerize(Billing billing) {
    return [
      [
        DisplayCell(
          lable: "Payment in",
          widget: SizedBox(
            child: Image(
              image: AssetImage(
                  "images/${billing.inCash ? "cash" : "google-pay"}.png"),
              fit: BoxFit.contain,
            ),
          ),
          onClick: billing.changePaymentType,
        ),
      ],
      [
        DisplayCell(
          lable: "Transfer",
          value: billing.transfer,
          active: true,
          onClick: billing.resetTransfer,
        )
      ],
      [
        DisplayCell(
          lable: "Total",
          value: billing.total,
          flex: 3,
        ),
        showListButton(showOrders: billing.openOrders, length: billing.length)
      ],
      [DisplayCell(lable: "Return", value: billing.returnCash)],
    ];
  }

  @override
  Widget build(BuildContext context) {
    var billing = Provider.of<T>(context);
    if (billing.loading) return loadingWigit;
    return DisplayBuilder(
      cellsIn2d: billing.focusedAt != Focuses.transfer
          ? order(billing)
          : summerize(billing),
    );
  }
}

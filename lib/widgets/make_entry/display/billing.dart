import 'package:flutter/material.dart';
import 'package:vdp/providers/make_entries/billing.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'custom/custom.dart';

enum Focuses { itemNum, quntity, price, transfer }

class BillingDisplay<T extends Billing> extends DisplayClass {
  const BillingDisplay({Key? key}) : super(key: key);

  List<List<DisplayCell>> order({
    required Focuses focusedAt,
    required String itemNum,
    required String name,
    required String quntity,
    required String rate,
    required String price,
    required String total,
    required void Function() selectItem,
    required void Function() showOrders,
    required void Function() selectQuntity,
    required void Function() selectAmount,
  }) {
    return [
      itemLine(
        active: focusedAt == Focuses.itemNum,
        itemNum: itemNum,
        selectItem: selectItem,
        showOrders: showOrders,
      ),
      [DisplayCell(lable: "Name", value: name)],
      [
        DisplayCell(
          lable: "Q",
          value: quntity,
          active: focusedAt == Focuses.quntity,
          onClick: selectQuntity,
        ),
        DisplayCell(
          lable: "A",
          value: price,
          active: focusedAt == Focuses.price,
          onClick: selectAmount,
        ),
      ],
      [
        DisplayCell(lable: "Rate", value: rate),
        DisplayCell(lable: "Total", value: total),
      ],
    ];
  }

  List<List<DisplayCell>> summerize({
    required String total,
    required String transfer,
    required bool inCash,
    required String returnCash,
    required void Function() showOrders,
    required void Function() changePaymentType,
  }) {
    return [
      [
        DisplayCell(
          lable: "Payment in",
          widget: SizedBox(
            child: Image(
              image: AssetImage("images/${inCash ? "cash" : "google-pay"}.png"),
              fit: BoxFit.contain,
            ),
          ),
          onClick: changePaymentType,
        ),
      ],
      [DisplayCell(lable: "Transfer", value: transfer, active: true)],
      [
        DisplayCell(
          lable: "Total",
          value: total,
          flex: 3,
        ),
        showListButton(showOrders: showOrders)
      ],
      [DisplayCell(lable: "Return", value: returnCash)],
    ];
  }

  @override
  Widget build(BuildContext context) {
    var billing = Provider.of<T>(context);
    if (billing.loading) return loadingWigit;
    return DisplayBuilder(
      cellsIn2d: billing.focusedAt != Focuses.transfer
          ? order(
              focusedAt: billing.focusedAt,
              itemNum: billing.itemCode,
              name: billing.name,
              quntity: billing.quntity,
              rate: billing.rate,
              price: billing.price,
              total: billing.total,
              selectItem: billing.openItemSelector,
              showOrders: billing.openOrders,
              selectAmount: billing.selectAmount,
              selectQuntity: billing.selectQuntity,
            )
          : summerize(
              inCash: billing.inCash,
              returnCash: billing.returnCash,
              transfer: billing.transfer,
              total: billing.total,
              showOrders: billing.openOrders,
              changePaymentType: billing.changePaymentType,
            ),
    );
  }
}

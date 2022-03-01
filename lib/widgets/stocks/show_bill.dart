import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/providers/apis/bill_provider.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class ShowBill extends StatelessWidget {
  const ShowBill({
    Key? key,
    required this.isFixed,
  }) : super(key: key);
  final bool isFixed;

  @override
  Widget build(BuildContext context) {
    var billProvider = Provider.of<BillProvider>(context, listen: false);
    var bill = billProvider.bill;
    return BuildPageBody(
      wrapScaffold: true,
      topic: "Bill Num: ${bill.billNum}",
      children: [
        InfoCell("Payment Done in", bill.inCash ? "Cash" : "G-Pay"),
        InfoCell("Bill Type", bill.isWholeSell ? "WholeSell" : "Retail"),
        InfoCell("Created By", getUserInfo(bill.uid)?.name),
        InfoCell("Money Given", rs_ + bill.moneyGiven.text),
        if (bill.note != null) InfoCell("NOTE", bill.note),
      ],
      trailing: [_BillOrderTable(orders: bill.orders)],
      floatingActionButton: isFixed ? null : const _DeleteButton(),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var billProvider = Provider.of<BillProvider>(context);
    return FloatingActionButton(
      heroTag: "Delete",
      onPressed: billProvider.deleteBill,
      backgroundColor: Colors.red,
      child: billProvider.loading ? loadingIconWigit : const Icon(Icons.delete),
    );
  }
}

class _BillOrderTable extends StatelessWidget {
  const _BillOrderTable({Key? key, required this.orders}) : super(key: key);
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return DisplayTable.fromString(
      titleNames: const ["Name", "Q", "A", "R"],
      data2D: orders.map(
        (e) => [e.item.name, e.quntity.text, rs_ + e.amount.text, e.rate.text],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/providers/apis/bill_provider.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:vdp/utils/typography.dart';

class ShowBill extends StatelessWidget {
  const ShowBill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var billProvider = Provider.of<BillProvider>(context, listen: false);
    var bill = billProvider.bill;
    return BuildPageBody(
      wrapScaffold: true,
      title: "Bill Num: ${bill.billNum}",
      children: [
        InfoCell("Payment Done in", bill.inCash ? "Cash" : "G-Pay"),
        InfoCell("Bill Type", bill.isWholeSell ? "WholeSell" : "Retail"),
        InfoCell("Created By", getUserInfo(bill.uid)?.name),
        InfoCell("Money Given", rs_ + bill.moneyGiven.text),
      ],
      trailing: [_BillOrderTable(orders: bill.orders)],
      floatingActionButton: const _DeleteButton(),
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
    return DataTable(
      columns: const [
        DataColumn(
            label: T2(
          "Name",
          color: Colors.purple,
        )),
        DataColumn(
            label: T2(
          "Quntity",
          color: Colors.purple,
        )),
        DataColumn(
            label: T2(
          "Amount",
          color: Colors.purple,
        )),
        DataColumn(
            label: T2(
          "Rate",
          color: Colors.purple,
        )),
      ],
      rows: orders
          .map(
            (e) => DataRow(cells: [
              DataCell(P3(e.item.name)),
              DataCell(P3(e.quntity.text)),
              DataCell(P3(rs_ + e.amount.text)),
              DataCell(P3(e.rate.text)),
            ]),
          )
          .toList(),
    );
  }
}

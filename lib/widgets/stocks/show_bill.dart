import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/providers/apis/bill_provider.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class ShowBill extends StatelessWidget {
  const ShowBill({Key? key}) : super(key: key);

  Container infoCell(String lable, String? info) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          Text(
            "$lable:",
            style: const TextStyle(fontSize: 30, color: Colors.purple),
          ),
          Text(info ?? "-- * --", style: const TextStyle(fontSize: 30)),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Center title(String billNum) {
    return Center(
      child: Text("BillNum: $billNum", style: const TextStyle(fontSize: 50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var billProvider = Provider.of<BillProvider>(context, listen: false);
    var bill = billProvider.bill;
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 20),
          title(billProvider.bill.billNum),
          const SizedBox(height: 20),
          infoCell("Payment Done in", bill.inCash ? "Cash" : "G-Pay"),
          const SizedBox(height: 10),
          infoCell("Bill Type", bill.isWholeSell ? "WholeSell" : "Retail"),
          const SizedBox(height: 10),
          infoCell("Created By", getUserInfo(bill.uid)?.name),
          const SizedBox(height: 10),
          infoCell("Money Given", rs_ + bill.moneyGiven.text),
          const SizedBox(height: 50),
          _BillOrderTable(orders: bill.orders),
        ],
      ),
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
      headingTextStyle: const TextStyle(fontSize: 40),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.purple),
      dataTextStyle: const TextStyle(fontSize: 30, color: Colors.black),
      columns: const [
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Quntity")),
        DataColumn(label: Text("Amount")),
        DataColumn(label: Text("Rate")),
      ],
      rows: orders
          .map(
            (e) => DataRow(cells: [
              DataCell(Text(e.item.name)),
              DataCell(Text(e.quntity.text)),
              DataCell(Text(rs_ + e.amount.text)),
              DataCell(Text(e.rate.text)),
            ]),
          )
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/transfer.dart';
import 'package:vdp/providers/apis/accept_transfer.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class ShowTransferRequest extends StatelessWidget {
  const ShowTransferRequest({Key? key}) : super(key: key);

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

  Center get title {
    return const Center(
      child: Text(
        "Recive Transfer ?",
        style: TextStyle(fontSize: 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var acceptTransfer = Provider.of<AcceptTransfer>(context, listen: false);
    final transfer = acceptTransfer.transfer;
    return Scaffold(
      body: ListView(
        children: [
          title,
          const SizedBox(height: 20),
          infoCell("Created By", getUserInfo(transfer.senderUid)?.name),
          const SizedBox(height: 10),
          infoCell("Send From", getStockInfo(transfer.transferFrom)?.name),
          const SizedBox(height: 50),
          _TransferTable(changes: transfer.stockChanges),
        ],
      ),
      floatingActionButton: const _ActionButton(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var acceptTransfer = Provider.of<AcceptTransfer>(context);
    return FloatingActionButton(
      onPressed: acceptTransfer.acceptTransfer,
      child:
          acceptTransfer.loading ? loadingIconWigit : const Icon(Icons.check),
    );
  }
}

class _TransferTable extends StatelessWidget {
  const _TransferTable({Key? key, required this.changes}) : super(key: key);
  final List<ChangesInTransfer> changes;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: const TextStyle(fontSize: 40),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.purple),
      dataTextStyle: const TextStyle(fontSize: 30, color: Colors.black),
      columns: const [
        DataColumn(label: Text("Product Name")),
        DataColumn(label: Text("Quntity Sent")),
      ],
      rows: changes
          .map((e) => DataRow(cells: [
                DataCell(Text(e.item.name)),
                DataCell(Text(e.quntitySent.text))
              ]))
          .toList(),
    );
  }
}

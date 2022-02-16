import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/transfer.dart';
import 'package:vdp/providers/apis/accept_transfer.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/page_utils.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class ShowTransferRequest extends StatelessWidget {
  const ShowTransferRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var acceptTransfer = Provider.of<AcceptTransfer>(context, listen: false);
    final transfer = acceptTransfer.transfer;
    return BuildPageBody(
      topic: "Recive Transfer ?",
      wrapScaffold: true,
      children: [
        InfoCell("Created By", getUserInfo(transfer.senderUid)?.name),
        InfoCell("Send From", getStockInfo(transfer.transferFrom)?.name),
      ],
      trailing: [_TransferTable(changes: transfer.stockChanges)],
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
    return DisplayTable.fromString(
      titleNames: const ["Name", "Sent"],
      data2D: changes.map((e) => [e.item.name, e.quntitySent.text]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/apis/bill_provider.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/stocks/show_bill.dart';
import 'package:provider/provider.dart';

class BillTile extends StatefulWidget {
  const BillTile({
    Key? key,
    required this.bill,
    required this.cancelBill,
    required this.cashCounterID,
    required this.stockID,
  }) : super(key: key);
  final Bill bill;
  final String stockID;
  final String cashCounterID;
  final Future<void> Function(
    String billNum,
    void Function() onStart,
    void Function() then,
  ) cancelBill;

  @override
  State<BillTile> createState() => _BillTileState();
}

class _BillTileState extends State<BillTile> {
  var loading = false;
  var disable = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => openBill(
        context,
        widget.bill,
        widget.stockID,
        widget.cashCounterID,
      ),
      leading: P2((widget.bill.isWholeSell ? "( W )" : "( R )")),
      trailing: FloatingActionButton(
        heroTag: "Delete-${widget.bill.billNum}",
        onPressed: () async {
          if (loading || disable) return;
          await widget.cancelBill(
              widget.bill.billNum,
              () => setState(() => loading = true),
              () => setState(() {
                    loading = false;
                    disable = true;
                  }));
        },
        backgroundColor: Colors.red,
        child: loading ? loadingIconWigit : const Icon(Icons.delete),
      ),
      subtitle: P3(rs_ + widget.bill.totalMoneyInString),
      title: T1(parseCode(widget.bill.billNum)),
    );
  }
}

void openBill(
  BuildContext context,
  Bill bill,
  String stockID,
  String cashCounterID,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ChangeNotifierProvider(
      create: (context) => BillProvider(context, bill, stockID, cashCounterID),
      child: const ShowBill(),
    );
  }));
}

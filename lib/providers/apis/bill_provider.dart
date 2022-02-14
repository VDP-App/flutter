import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';

class BillProvider extends Modal with ChangeNotifier {
  final Bill bill;
  var _loading = false;
  final _cancleEntryOnCloud = CancleEntryOnCloud();
  final String cashCounterID;
  final String stockID;

  BillProvider(
    BuildContext context,
    this.bill,
    this.stockID,
    this.cashCounterID,
  ) : super(context);

  get loading => _loading;

  void deleteBill() async {
    if (_loading || !await shouldProceed("Cancle Bill?")) return;
    _loading = true;
    notifyListeners();
    await handleCloudCall(
      _cancleEntryOnCloud.cancleBill(bill.billNum, stockID, cashCounterID),
    );
    Navigator.pop(context);
  }
}

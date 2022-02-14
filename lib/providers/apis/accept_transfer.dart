import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/transfer.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';

class AcceptTransfer extends Modal with ChangeNotifier {
  final String stockID;
  TransferNotifications transfer;
  final transferStockOnCloud = TransferStockOnCloud();
  var _loading = false;

  AcceptTransfer(
    BuildContext context,
    this.stockID,
    this.transfer,
  ) : super(context);

  bool get loading => _loading;

  Future<void> acceptTransfer() async {
    if (_loading) return;
    if (await shouldProceed("Accept Transfer?")) {
      _loading = true;
      notifyListeners();
      await handleCloudCall(
        transferStockOnCloud.reciveTransfer(transfer.uniqueID, stockID),
      );
      Navigator.pop(context);
    }
  }
}

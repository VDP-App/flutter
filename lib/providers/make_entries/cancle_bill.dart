import 'package:flutter/material.dart';
import 'package:vdp/widgets/make_entry/ui/builder.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';

class CancleBill extends Modal with ChangeNotifier {
  final _cancleEntryOnCloud = CancleEntryOnCloud();
  String _billNum = "";
  final String stockID;
  final String cashCounterID;
  var _loading = false;

  CancleBill(
    BuildContext context,
    this.stockID,
    this.cashCounterID,
  ) : super(context);

  void _cancleBill() async {
    if (!await shouldProceed("Cancle Bill?")) return;
    _loading = true;
    notifyListeners();
    await handleCloudCall(
      _cancleEntryOnCloud.cancleBill(_billNum, stockID, cashCounterID),
      (value) {
        openModal("Bill was deleted", "$_billNum was successfully deleted");
      },
    );
    _loading = false;
    _billNum = "";
    notifyListeners();
  }

  void clear() {
    onClick(KeybordKeyValue.action1);
  }

  void _onClick(KeybordKeyValue key) {
    if (_billNum.isEmpty && key == KeybordKeyValue.num0) return;
    var number = key.num;
    if (number != null) {
      if (_billNum.length <= 3) _billNum += number;
      return;
    }
    if (_billNum.isEmpty) return;
    if (key == KeybordKeyValue.enter) return _cancleBill();
    _billNum = "";
  }

  String get billNum => _billNum;
  bool get loading => _loading;

  void onClick(KeybordKeyValue key) {
    if (_loading) return;
    _onClick(key);
    notifyListeners();
  }
}

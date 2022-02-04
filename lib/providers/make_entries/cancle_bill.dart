import 'package:flutter/material.dart';
import 'package:vdp/widgets/make_entry/keybord/builder.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';
import 'package:intl/intl.dart';

String get billNumKey => DateFormat('bill-yyyy-MM-dd').format(DateTime.now());

class CancleBill extends Modal with ChangeNotifier {
  final _cancleBillOnCloud = CancleBillOnCloud();
  var _billNum = sharedPreferences.getInt(billNumKey)?.toString() ?? "";
  final String? _stockID;
  final String? _cashCounterID;
  var _loading = false;

  CancleBill(
    BuildContext context,
    this._stockID,
    this._cashCounterID,
  ) : super(context);

  void _cancleBill() async {
    if (!await shouldProceed()) return;
    final stockID = _stockID, cashCounterID = _cashCounterID;
    if (stockID == null || cashCounterID == null) return;
    _loading = true;
    notifyListeners();
    await handleCloudCall(
      _cancleBillOnCloud.cancleBill(_billNum, stockID, cashCounterID),
      (value) {
        openModal("Bill was deleted", "$_billNum was successfully deleted");
      },
    );
    _loading = false;
    _billNum = "";
    notifyListeners();
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

import 'package:flutter/material.dart';
import 'package:vdp/documents/cash_counter.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:vdp/utils/modal.dart';

String _docPath(String stockID, String cashCounterID) =>
    "stocks/$stockID/cashCounters/$cashCounterID";

CashCounterDoc _computeFn(Map<String, dynamic> data) {
  return CashCounterDoc.fromJson(data);
}

class CashCounter extends Modal with ChangeNotifier {
  String? _stockID;
  String? _cashCounterID;
  CashCounterDoc? _doc;
  final _cancleEntryOnCloud = CancleEntryOnCloud();

  CashCounter(BuildContext context) : super(context);

  void refresh() {
    final stockID = _stockID, cashCounterID = _cashCounterID;
    if (stockID == null || cashCounterID == null) return;
    getDoc(
      docPath: _docPath(stockID, cashCounterID),
      converter: _computeFn,
      getDocFrom: GetDocFrom.serverIfNotThenCache,
    ).then((value) {
      _doc = value;
      notifyListeners();
    }).onError((error, stackTrace) {
      openModal(error.toString(), stackTrace.toString());
    });
  }

  void update(String stockID, String cashCounterID) {
    if (stockID == _stockID && cashCounterID == _cashCounterID) return;
    _stockID = stockID;
    _cashCounterID = cashCounterID;
    _doc = null;
    refresh();
    notifyListeners();
  }

  CashCounterDoc? get doc => _doc;
  String? get stockID => _stockID;
  String? get cashCounterID => _cashCounterID;

  Future<void> cancelBill(
    String billNum,
  ) async {
    final stockID = _stockID, cashCounterID = _cashCounterID;
    if (stockID == null || cashCounterID == null) return;
    await _cancleEntryOnCloud.cancleBill(
      billNum,
      stockID,
      cashCounterID,
    );
  }
}

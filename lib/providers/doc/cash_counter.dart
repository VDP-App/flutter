import 'package:flutter/foundation.dart';
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
  void Function()? _cancel;
  String? _stockID;
  String? _cashCounterID;
  CashCounterDoc? _doc;
  final _cancleBillOnCloud = CancleBillOnCloud();

  CashCounter(BuildContext context) : super(context);

  void update(String stockID, String cashCounterID) {
    if (stockID == _stockID && cashCounterID == _cashCounterID) return;
    _stockID = stockID;
    _cashCounterID = cashCounterID;
    _cancel?.call();
    _doc = null;
    _cancel = FirestoreDoc<CashCounterDoc>(
      documentPath: _docPath(stockID, cashCounterID),
      converter: (doc) {
        return compute<Map<String, dynamic>, CashCounterDoc>(_computeFn, doc);
      },
    ).stream.listen(
      (event) {
        _doc = event;
        notifyListeners();
      },
      cancelOnError: false,
      onError: (e) => openModal("Error Occured", e.toString()),
    ).cancel;
    notifyListeners();
  }

  CashCounterDoc? get doc => _doc;
  String? get stockID => _stockID;
  String? get cashCounterID => _cashCounterID;

  Future<void> cancelBill(
    String billNum,
    void Function() onStart,
    void Function() then,
  ) async {
    final stockID = _stockID, cashCounterID = _cashCounterID;
    if (stockID == null || cashCounterID == null || !await shouldProceed()) {
      return;
    }
    onStart();
    await _cancleBillOnCloud
        .cancleBill(
          billNum,
          stockID,
          cashCounterID,
        )
        .then((_) => then());
  }

  @override
  void dispose() {
    super.dispose();
    _cancel?.call();
  }
}

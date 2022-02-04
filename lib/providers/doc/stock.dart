import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vdp/documents/stock.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:vdp/utils/modal.dart';

const _collectionPath = "stocks";

StockDoc _computeFn(Map<String, dynamic> data) {
  return StockDoc.fromJson(data);
}

class Stock extends Modal with ChangeNotifier {
  StreamSubscription<StockDoc>? _streamSubscription;
  String? _stockID;
  StockDoc? _doc;
  final transferStockOnCloud = TransferStockOnCloud();

  Stock(BuildContext context) : super(context);

  StockDoc? get doc => _doc;

  void update(String stockID, {required bool isNotManager}) {
    if (isNotManager || stockID != _stockID) _streamSubscription?.cancel();
    if (!isNotManager && stockID != _stockID) {
      _doc = null;
      _stockID = stockID;
      _streamSubscription = FirestoreDoc<StockDoc>(
        documentPath: _collectionPath + "/" + stockID,
        converter: (doc) {
          return compute<Map<String, dynamic>, StockDoc>(_computeFn, doc);
        },
      ).stream.listen(
        (event) {
          _doc = event;
          notifyListeners();
        },
        cancelOnError: false,
        onError: (e) => openModal("Error Occured", e.toString()),
      );
    } else {
      _stockID = stockID;
    }
    notifyListeners();
  }

  Future<void> acceptTransfer(String uniqueID) async {
    final stockID = _stockID;
    if (stockID == null) return;
    return await transferStockOnCloud.reciveTransfer(uniqueID, stockID);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}

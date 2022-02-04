import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vdp/documents/config.dart';
import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:vdp/utils/modal.dart';

const _collectionPath = "config";
const _docID = "config";

ConfigDoc _computeFn(Map<String, dynamic> data) {
  return ConfigDoc.fromJson(data);
}

UserInfo? getUserInfo(String uid) => Config._currentDoc?.getUserInfo(uid);
StockInfo? getStockInfo(String stockID) =>
    Config._currentDoc?.getStockInfo(stockID);

class Config extends Modal with ChangeNotifier {
  late final Function _cancel;
  ConfigDoc? _doc;
  final _editShopOnCloud = EditShopOnCloud();
  var _loading = false;

  static ConfigDoc? _currentDoc;

  Config(BuildContext context) : super(context) {
    _cancel = FirestoreDoc<ConfigDoc>(
      documentPath: _collectionPath + "/" + _docID,
      converter: (doc) {
        return compute<Map<String, dynamic>, ConfigDoc>(_computeFn, doc);
      },
    ).stream.listen(
      (event) {
        _doc = event;
        _currentDoc = event;
        notifyListeners();
      },
      cancelOnError: false,
      onError: (e) => openModal("Error Occured", e.toString()),
    ).cancel;
  }

  ConfigDoc? get doc => _doc;
  bool get loading => _loading;

  @override
  Future<void> handleCloudCall<T>(
    Future<T> future, [
    void Function(T val)? then,
  ]) async {
    _loading = true;
    notifyListeners();
    await super.handleCloudCall(future, then);
    _loading = false;
    notifyListeners();
  }

  Future<void> createStock() async {
    if (_loading) return;
    final name = await getName("ADD Stock");
    if (name == null || name.isEmpty) return;
    return handleCloudCall(_editShopOnCloud.createStock(name));
  }

  Future<void> editStock(StockInfo stockInfo) async {
    if (_loading) return;
    final name = await getName("Change Stock Name", stockInfo.name);
    if (name == null || name.isEmpty || name == stockInfo.name) return;
    return handleCloudCall(_editShopOnCloud.editStock(name, stockInfo.id));
  }

  Future<void> createCashCounter(StockInfo stockInfo) async {
    if (_loading) return;
    final name = await getName("Create Cash Counter");
    if (name == null || name.isEmpty) return;
    return handleCloudCall(
      _editShopOnCloud.createCashCounter(name, stockInfo.id),
    );
  }

  Future<void> editCashCounter(
    StockInfo stockInfo,
    CashCounterInfo cashCounterInfo,
  ) async {
    if (_loading) return;
    final name = await getName(
      "Change Cash Counter Name",
      cashCounterInfo.name,
    );
    if (name == null || name.isEmpty || name == cashCounterInfo.name) return;
    return handleCloudCall(_editShopOnCloud.editCashCounter(
      name,
      stockInfo.id,
      cashCounterInfo.id,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _cancel();
  }
}

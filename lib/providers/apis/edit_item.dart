import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/modal.dart';

class EditProduct extends Modal with ChangeNotifier {
  final Product? product;
  final Iterable<String> collectionNames;
  final List<String> _codeNumList;
  final _editItemOnCloud = EditItemOnCloud();

  var _name = "";
  String? _collectionName;
  var _code = "";
  var _rate1 = .0;
  var _rate2 = .0;
  var _cgst = .0;
  var _sgst = .0;
  var _loading = false;
  var _deleteLoading = false;

  EditProduct(
    BuildContext context,
    this.product,
    this.collectionNames,
    this._codeNumList,
  ) : super(context) {
    _name = product?.name ?? "";
    _code = product?.code ?? "";
    _collectionName = product?.collectionName;
    _rate1 = product?.rate1 ?? 0;
    _rate2 = product?.rate2 ?? 0;
    _cgst = product?.cgst ?? 0;
    _sgst = product?.sgst ?? 0;
  }

  void onNameChanged(String string) {
    _name = string;
    notifyListeners();
  }

  void onCollectionNameChanged(String string) {
    _collectionName = string;
    notifyListeners();
  }

  void onCodeChanged(String string) {
    _code = parseCode(string);
    notifyListeners();
  }

  void onRate1Changed(String string) {
    _rate1 = double.tryParse(string) ?? 0;
    notifyListeners();
  }

  void onRate2Changed(String string) {
    _rate2 = double.tryParse(string) ?? 0;
    notifyListeners();
  }

  void onCgstChanged(String string) {
    _cgst = double.tryParse(string) ?? 0;
    notifyListeners();
  }

  void onSgstChanged(String string) {
    _sgst = double.tryParse(string) ?? 0;
    notifyListeners();
  }

  bool get loading => _loading;
  bool get deleteLoading => _deleteLoading;

  bool get isReady {
    if (_name.isEmpty ||
        _collectionName == null ||
        _code.isEmpty ||
        _rate1 <= 0 ||
        _rate2.isNegative ||
        _cgst.isNegative ||
        _sgst.isNegative) return false;
    final _product = product;
    if (_product == null) {
      if (_codeNumList.contains(_code)) return false;
      return true;
    }
    if (_code != _product.code) {
      if (_codeNumList.contains(_code)) return false;
      return true;
    }
    if (_name != _product.name) return true;
    if (_collectionName != _product.collectionName) return true;
    if (_rate1 != _product.rate1) return true;
    if (_rate2 != _product.rate2) return true;
    if (_cgst != _product.cgst) return true;
    if (_sgst != _product.sgst) return true;
    return false;
  }

  bool get isNotReady => !isReady;

  Future<void> applyChanges() async {
    if (_loading || _deleteLoading || isNotReady) return;
    _loading = true;
    notifyListeners();
    final _product = Product.fromInput(
      code: _code,
      collectionName: _collectionName!,
      name: _name,
      rate1: _rate1,
      rate2: _rate2,
      cgst: _cgst,
      sgst: _sgst,
      id: product?.id,
    );
    if (product != null) {
      await handleCloudCall(_editItemOnCloud.update(_product));
    } else {
      await handleCloudCall(_editItemOnCloud.create(_product));
    }
    Navigator.pop(context);
    _loading = false;
    notifyListeners();
  }

  Future<void> removeItem() async {
    final _product = product;
    if (_loading || _deleteLoading || _product == null) return;
    _deleteLoading = true;
    notifyListeners();
    await handleCloudCall(_editItemOnCloud.remove(_product));
    _deleteLoading = false;
    notifyListeners();
    Navigator.pop(context);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:vdp/utils/modal.dart';

const _collectionPath = "config";
const _docID = "products";

ProductDoc _computeFn(Map<String, dynamic> data) {
  return ProductDoc.fromJson(data);
}

ProductDoc? get productDoc => _productsDoc;

ProductDoc? _productsDoc;

class Products extends Modal with ChangeNotifier {
  late final Function _cancel;
  ProductDoc? _doc;

  Products(BuildContext context) : super(context) {
    _cancel = FirestoreDoc<ProductDoc>(
      documentPath: _collectionPath + "/" + _docID,
      converter: (doc) {
        return compute<Map<String, dynamic>, ProductDoc>(_computeFn, doc);
      },
    ).stream.listen(
      (event) {
        _doc = event;
        _productsDoc = event;
        notifyListeners();
      },
      cancelOnError: false,
      onError: (e) => openModal("Error Occured", e.toString()),
    ).cancel;
  }

  ProductDoc? get doc => _doc;

  @override
  void dispose() {
    super.dispose();
    _cancel();
  }
}

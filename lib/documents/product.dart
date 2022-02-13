import 'package:vdp/documents/utils/parsing.dart';

import 'utils/product.dart';

const allCollectionNameKey = "#All";

class ProductDoc {
  final Map<String, Product> _items;
  final Map<String, Set<Product>> _collection;
  final Map<String, Product> _codes;
  final int logPage;
  final Set<Product> _deletedItem;

  const ProductDoc(
    this._items,
    this._collection,
    this._codes,
    this.logPage,
    this._deletedItem,
  );

  factory ProductDoc.fromJson(Map<String, dynamic> data) {
    final _items = <String, Product>{};
    final _collection = {allCollectionNameKey: <Product>{}};
    final _codes = <String, Product>{};
    final _deletedItem = <Product>{};

    for (var item in asMap(data["items"]).entries) {
      if (item.value is Map) {
        var _item = Product.fromJSON(item.key, item.value);
        _items[_item.id] = _item;

        if (_item.code != null && _item.collectionName != null) {
          _collection[allCollectionNameKey]?.add(_item);

          _codes[_item.code as String] = _item;

          if (!_collection.containsKey(_item.collectionName)) {
            _collection[_item.collectionName as String] = <Product>{};
          }

          _collection[_item.collectionName]?.add(_item);
        } else {
          _deletedItem.add(_item);
        }
      }
    }

    return ProductDoc(
      _items,
      _collection,
      _codes,
      asInt(asMap(data["log"])["page"]),
      _deletedItem,
    );
  }

  Product? operator [](String id) => _items[id];

  Product? getItemBy({String? id, String? code}) {
    if (id != null) {
      return _items[id];
    } else if (code != null) {
      return _codes[("0000" + code).substring(code.length)];
    } else {
      return null;
    }
  }

  Set<Product> get deleatedItems => _deletedItem;

  Set<Product>? getItemInCollection(String? collectionName) {
    return _collection[collectionName];
  }

  Iterable<String> get collectionNames => _collection.keys;

  List<String> get codeNums {
    final arr = _codes.keys.toList();
    arr.sort();
    return arr;
  }
}

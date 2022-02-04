import 'package:vdp/documents/utils/parsing.dart';

import 'utils/product.dart';

class ProductDoc {
  final Map<String, Product> _items;
  final Map<String, Set<Product>> _collection;
  final Map<String, Product> _codes;
  final int logPage;

  const ProductDoc(this._items, this._collection, this._codes, this.logPage);

  factory ProductDoc.fromJson(Map<String, dynamic> data) {
    final _items = <String, Product>{};
    final _collection = <String, Set<Product>>{};
    final _codes = <String, Product>{};

    for (var item in asMap(data["items"]).entries) {
      if (item.value is Map) {
        var _item = Product.fromJSON(item.key, item.value);

        _items[_item.id] = _item;

        if (_item.code != null && _item.collectionName != null) {
          _codes[_item.code as String] = _item;

          if (!_collection.containsKey(_item.collectionName)) {
            _collection[_item.collectionName as String] = <Product>{};
          }

          _collection[_item.collectionName]?.add(_item);
        }
      }
    }

    return ProductDoc(
      _items,
      _collection,
      _codes,
      asInt(asMap(data["log"])["page"]),
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

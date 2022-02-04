import 'package:flutter/material.dart';
import 'package:vdp/widgets/selectors/select_item.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/utils/product.dart';

class ItemCode {
  var _code = "";
  ProductDoc? _items;
  Product? _selectedItem;

  ItemCode();

  void update(ProductDoc items) {
    _items = items;
  }

  String get code => _code;
  String get name => _selectedItem?.name ?? "";
  Product? get item => _selectedItem;
  bool get hasItem => _selectedItem != null;
  bool get isEmpty => _code.isEmpty;

  void changeCodeTo(String code) {
    if (code.length < 5) {
      _selectedItem = _items?.getItemBy(code: code);
      _code = code;
    }
  }

  String operator +(String x) => _code + x;

  void changeItemTo(Product item) {
    _selectedItem = item;
    _code = item.code ?? "";
  }

  Future<void> openItemSelector(
    BuildContext context,
    void Function(Product item) onSelect,
  ) async {
    await selectItem(context, _items, (Product item) {
      changeItemTo(item);
      onSelect(item);
    });
  }

  @override
  toString() => _code;
}

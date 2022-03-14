import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/main.dart';

class DefaultStockList extends StatelessWidget {
  const DefaultStockList({
    Key? key,
    required this.products,
    required this.consumption,
  }) : super(key: key);
  final List<Product> products;
  final Map<String, double> consumption;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, i) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, i) {
          final item = products.elementAt(i);
          return TextField(
            onChanged: (value) {
              consumption[item.id] = double.tryParse(value) ?? 0;
            },
            keyboardType: TextInputType.number,
            style:
                TextStyle(fontSize: isTablet ? fontSizeOf.t2 : fontSizeOf.t1),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: item.name,
            ),
          );
        });
  }
}

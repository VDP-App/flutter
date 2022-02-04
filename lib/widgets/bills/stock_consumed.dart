import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/providers/doc/cash_counter.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/selectors/select_item.dart';
import 'package:provider/provider.dart';

class StockConsumed extends StatefulWidget {
  const StockConsumed({Key? key}) : super(key: key);

  @override
  State<StockConsumed> createState() => _StockConsumedState();
}

class _StockConsumedState extends State<StockConsumed> {
  Product? selectedItem;

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Products>(context);
    var cashCounter = Provider.of<CashCounter>(context);
    final stockConsumed = cashCounter.doc?.stockConsumed;
    final doc = product.doc;
    if (doc == null || stockConsumed == null) {
      return const Center(child: loadingWigitLinier);
    }
    final item = selectedItem;
    return Card(
      elevation: 8,
      shadowColor: Colors.lightBlue,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item != null
                        ? item.name
                        : "Select Item for Quntity Consumed",
                    style: const TextStyle(fontSize: 45, color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                    child: Text(
                      item != null
                          ? (stockConsumed[item.id]?.text ?? "0") +
                              " Quntity Consumed"
                          : "Click on button -->",
                      style:
                          const TextStyle(fontSize: 40, color: Colors.white70),
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.large(
                heroTag: "item-selector",
                backgroundColor: Colors.deepOrange,
                child: const Icon(Icons.drive_folder_upload_outlined),
                onPressed: () => selectItem(
                  context,
                  doc,
                  (item) => setState(() => selectedItem = item),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

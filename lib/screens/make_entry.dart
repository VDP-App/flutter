import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/apis/blutooth.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/widgets/make_entry/ui/ui.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';
import 'package:vdp/widgets/selectors/select_entry_mode.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/providers/make_entries/make_entries.dart';
import 'package:provider/provider.dart';

class MakeEntryPage extends StatefulWidget {
  const MakeEntryPage({Key? key}) : super(key: key);

  @override
  State<MakeEntryPage> createState() => _MakeEntryPageState();
}

class _MakeEntryPageState extends State<MakeEntryPage> {
  SelectedType _selectedType =
      SelectedType.values.elementAt(sharedPreferences.getInt("entry") ?? 0);

  void selectMode(bool isAccountent) async {
    final selectedType = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SelectEntryMode(
            selectedType: _selectedType,
            isAccountent: isAccountent,
          );
        },
      ),
    );
    if (selectedType is SelectedType && selectedType != _selectedType) {
      setState(() {
        _selectedType = selectedType;
        sharedPreferences.setInt("entry", selectedType.index);
      });
    }
  }

  Widget Function(Auth auth) modeSelector(BuildContext context) {
    return (auth) {
      final child = SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: _selectedType.build(),
        ),
      );
      return TextButton(
        onPressed: () => selectMode(auth.claims?.isAccountent ?? false),
        style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: Colors.grey[300],
        ),
        child: isTablet
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: child,
              )
            : child,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = _selectedType;
    final location = Provider.of<Location>(context);
    final stockID = location.stockID, cashCounterID = location.cashCounterID;
    if (stockID == null || cashCounterID == null) {
      return SelectLocationButton.fromLocation(location, "To Make an entry");
    }
    final printBill = Provider.of<BlutoothProvider>(context).printBill;
    if (selectedType.isBilling) {
      if (selectedType == SelectedType.wholeSellBill) {
        return MultiProvider(
          providers: [
            Provider<Widget Function(Auth auth)>(create: modeSelector),
            ChangeNotifierProxyProvider2<Products, Location, WholeSellBilling>(
              create: (context) =>
                  WholeSellBilling(context, stockID, cashCounterID, printBill),
              update: (context, products, _, previous) {
                previous ??= WholeSellBilling(
                    context, stockID, cashCounterID, printBill);
                final items = products.doc;
                if (items != null) {
                  previous.update(items, stockID, cashCounterID);
                }
                return previous;
              },
            ),
          ],
          child: const BillingUI<WholeSellBilling>(),
        );
      } else {
        return MultiProvider(
          providers: [
            Provider<Widget Function(Auth auth)>(create: modeSelector),
            ChangeNotifierProxyProvider2<Products, Location, RetailBilling>(
              create: (context) =>
                  RetailBilling(context, stockID, cashCounterID, printBill),
              update: (context, products, _, previous) {
                previous ??=
                    RetailBilling(context, stockID, cashCounterID, printBill);
                final items = products.doc;
                if (items != null) {
                  previous.update(items, stockID, cashCounterID);
                }
                return previous;
              },
            ),
          ],
          child: const BillingUI<RetailBilling>(),
        );
      }
    } else if (selectedType == SelectedType.cancleBill) {
      return MultiProvider(
        providers: [
          Provider<Widget Function(Auth auth)>(create: modeSelector),
          ChangeNotifierProxyProvider<Location, CancleBill>(
            create: (context) => CancleBill(context, stockID, cashCounterID),
            update: (context, location, previous) {
              previous ??= CancleBill(context, stockID, cashCounterID);
              previous.update(stockID, cashCounterID);
              return previous;
            },
          ),
        ],
        child: const CancleBillUI(),
      );
    }
    final stock = Provider.of<Stock>(context);
    final stockDoc = stock.doc;
    if (stockDoc == null) return loadingWigit;
    if (selectedType == SelectedType.transfer) {
      return MultiProvider(
        providers: [
          Provider<Widget Function(Auth auth)>(create: modeSelector),
          ChangeNotifierProxyProvider4<Products, Stock, Config, Location,
              TransferStock>(
            create: (context) => TransferStock(context, stockID),
            update: (context, products, __, config, _, previous) {
              previous ??= TransferStock(context, stockID);
              final items = products.doc;
              final configDoc = config.doc;
              if (items != null && configDoc != null) {
                previous.updateTransfer(stockDoc, items, configDoc, stockID);
              }
              return previous;
            },
          ),
        ],
        child: const StockUI<TransferStock>(),
      );
    } else if (selectedType == SelectedType.setStock) {
      return MultiProvider(
        providers: [
          Provider<Widget Function(Auth auth)>(create: modeSelector),
          ChangeNotifierProxyProvider3<Products, Stock, Location, StockSetting>(
            create: (context) => StockSetting(context, stockID),
            update: (context, products, __, _, previous) {
              previous ??= StockSetting(context, stockID);
              final items = products.doc;
              if (items != null) {
                previous.update(stockDoc, items, stockID);
              }
              return previous;
            },
          ),
        ],
        child: const StockUI<StockSetting>(),
      );
    } else {
      return MultiProvider(
        providers: [
          Provider<Widget Function(Auth auth)>(create: modeSelector),
          ChangeNotifierProxyProvider3<Products, Stock, Location, ProduceStock>(
            create: (context) => ProduceStock(context, stockID),
            update: (context, products, __, _, previous) {
              previous ??= ProduceStock(context, stockID);
              final items = products.doc;
              if (items != null) {
                previous.update(stockDoc, items, stockID);
              }
              return previous;
            },
          ),
        ],
        child: const StockUI<ProduceStock>(),
      );
    }
  }
}

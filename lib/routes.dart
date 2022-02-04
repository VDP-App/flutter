import 'package:flutter/material.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/screens/login.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';

class RouteApp extends StatelessWidget {
  const RouteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    if (auth.isLoggedIn) {
      final claims = auth.claims;
      final isManager = auth.claims?.hasManagerAuthorization ?? false;
      if (claims == null) return loadingWigit;
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<Config>(
            create: (_context) => Config(_context),
            lazy: false,
          ),
          ChangeNotifierProvider<Products>(
            create: (_context) => Products(_context),
            lazy: false,
          ),
          ChangeNotifierProxyProvider<Config, Location>(
            create: (_context) => Location(_context, claims),
            update: (_context, _config, _location) {
              _location ??= Location(_context, claims);
              final doc = _config.doc;
              if (doc != null) _location.update(doc);
              return _location;
            },
          ),
          ChangeNotifierProxyProvider<Location, Stock>(
            create: (context) => Stock(context),
            update: (_context, _location, _stock) {
              _stock ??= Stock(_context);
              final _stockID = _location.stockID;
              if (_stockID != null) {
                _stock.update(_stockID, isNotManager: !isManager);
              }
              return _stock;
            },
          )
        ],
        child: const Layout(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Vardayani Dairy Products')),
      body: auth.isLoading ? loadingWigit : const Login(),
    );
  }
}

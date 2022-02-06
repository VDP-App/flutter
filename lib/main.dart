import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/auth.dart';
import 'package:vdp/utils/fontsize.dart';
import 'package:vdp/providers/apis/pages.dart';
import 'package:vdp/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'routes.dart';

SharedPreferences? _sharedPreferences;
var _fontSize = const FontSize.phone();
bool _isTablet = false;

FontSize get fontSizeOf => _fontSize;
bool get isTablet => _isTablet;
SharedPreferences get sharedPreferences {
  if (_sharedPreferences == null) throw "no local-storage enabled";
  return _sharedPreferences as SharedPreferences;
}

Future<void> init() async {
  await Firebase.initializeApp();
  _sharedPreferences = await SharedPreferences.getInstance();
}

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.deepPurple,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: SizedBox(
                    height: 50,
                    child: FittedBox(fit: BoxFit.contain, child: Text("Error")),
                  ),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => Auth(context)),
                ChangeNotifierProvider(create: (context) => PageProvider()),
              ],
              child: const RouteApp(),
            );
          }
          final size = MediaQuery.of(context).size;
          var diagonal =
              sqrt((size.width * size.width) + (size.height * size.height));
          if (diagonal > 1100.0) {
            _isTablet = true;
            _fontSize = const FontSize.tablet();
          } else {
            _isTablet = false;
            _fontSize = const FontSize.phone();
          }
          return Scaffold(body: loadingWigit);
        },
      ),
    );
  }
}

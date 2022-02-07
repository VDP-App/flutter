import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/config_info.dart';
import 'package:vdp/providers/doc/config.dart';
import 'package:vdp/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:vdp/utils/typography.dart';

class EditShop extends StatelessWidget {
  const EditShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var config = Provider.of<Config>(context);
    final stocks = config.doc?.stocks;
    if (stocks == null) return loadingWigit;
    const divider = Divider(thickness: 3);
    const space = SizedBox(height: 15);
    final children = <Widget>[
      loading(config),
      const SizedBox(height: 10),
      addStockButton(config),
      space,
    ];
    for (var stock in stocks) {
      children.addAll([
        divider,
        stockTile(stock, config),
        space,
        addCashCounterButton(config, stock),
        space,
      ]);
      for (var cashCounter in stock.cashCounters) {
        children.add(cashCounterTile(cashCounter, config, stock));
        children.add(space);
      }
    }
    children.add(const Divider(thickness: 3));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: children),
    );
  }

  Widget cashCounterTile(
    CashCounterInfo cashCounter,
    Config config,
    StockInfo stock,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ListTile(
        leading: FloatingActionButton(
          mini: true,
          heroTag: cashCounter,
          onPressed: () => config.editCashCounter(stock, cashCounter),
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.edit_outlined),
        ),
        title: P3(cashCounter.name),
      ),
    );
  }

  Widget addCashCounterButton(Config config, StockInfo stock) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton.icon(
        onPressed: () => config.createCashCounter(stock),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromHeight(50),
          primary: Colors.blue,
        ),
        icon: const Icon(Icons.add),
        label: const T1("Add Cash Counter"),
      ),
    );
  }

  Widget stockTile(StockInfo stock, Config config) {
    return ListTile(
      leading: FloatingActionButton(
        heroTag: stock,
        onPressed: () => config.editStock(stock),
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.edit_outlined),
      ),
      title: T1(stock.name),
    );
  }

  Widget addStockButton(Config config) {
    return ElevatedButton.icon(
      onPressed: config.createStock,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size.fromHeight(50),
        primary: Colors.green,
      ),
      icon: const Icon(Icons.add),
      label: const T1("Add Stock"),
    );
  }

  Widget loading(Config config) {
    return Visibility(
      maintainAnimation: true,
      maintainSize: true,
      maintainState: true,
      visible: config.loading,
      child: loadingWigitLinier,
    );
  }
}

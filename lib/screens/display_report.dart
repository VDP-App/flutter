import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/documents/cash_counter.dart';
import 'package:vdp/documents/product.dart';
import 'package:vdp/documents/stock.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/providers/doc/cash_counter.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/stock.dart';
import 'package:vdp/utils/display_table.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/modal.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/selectors/open_location_selector.dart';

// ! today
// ?    stockConsumed => Table
// ?    currentStock => Table
// ! previous Date
// ?    retail-sells => Table
// ?    whole-sells => List
// ?    stockChanges => List
// ?    stockAtEnd => Table

class DisplayReport extends StatelessWidget {
  const DisplayReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final stockID = location.stockID, cashCounterID = location.cashCounterID;
    if (stockID == null || cashCounterID == null) {
      return SelectLocationButton.fromLocation(location, "To See ");
    }
    final products = Provider.of<Products>(context);
    final productsDoc = products.doc;
    if (productsDoc == null) return loadingWigit;
    final cashCounter = Provider.of<CashCounter>(context);
    final cashCounterDoc = cashCounter.doc;
    final stock = Provider.of<Stock>(context);
    final stockDoc = stock.doc;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const Center(child: H2("Today's Stock")),
          const Divider(thickness: 2),
          Row(children: [
            _CardButton(
              title: "Consumed",
              color: Colors.redAccent,
              onTap: () =>
                  openRetailReport(context, cashCounterDoc!, productsDoc),
              isInfo: true,
              isLoading: cashCounterDoc == null,
            ),
            _CardButton(
              title: "Current",
              color: Colors.blueAccent,
              onTap: () =>
                  openCurrentStockReport(context, stockDoc!, productsDoc),
              isInfo: true,
              isLoading: stockDoc == null,
            )
          ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          Divider(thickness: 2.5, height: fontSizeOf.p3),
          const Center(child: H2("Summery Report")),
          _CardButton(
            iconData: Icons.date_range_rounded,
            title: "Change Date",
            subtitle: "Selected Date: 10-12-2001",
            color: Colors.black,
            onTap: () => launchWidgit(
              context,
              "Select Date",
              SizedBox(
                height: fontSizeOf.x2,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    // Do something
                  },
                ),
              ),
            ),
          ),
          const Divider(thickness: 2),
          _CardButton(
            iconData: Icons.store,
            title: "Retail Sells",
            subtitle: "Net Income $rs 25,000",
            color: Colors.indigoAccent,
            onTap: () {},
          ),
          _CardButton(
            iconData: Icons.account_balance_wallet_rounded,
            title: "Wholesell Sells",
            subtitle: "2 bills",
            color: Colors.deepOrangeAccent,
            onTap: () {},
          ),
          _CardButton(
            iconData: Icons.change_circle_sharp,
            title: "Stock Changes",
            subtitle: "9 entries",
            color: Colors.pinkAccent,
            onTap: () {},
          ),
          _CardButton(
            iconData: Icons.report,
            title: "Stock At End",
            subtitle: "Stock Remaining at End of the day",
            color: Colors.blueAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({
    Key? key,
    this.subtitle,
    required this.title,
    required this.color,
    required this.onTap,
    this.isInfo = false,
    this.iconData,
    this.isLoading = false,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final Color color;
  final void Function() onTap;
  final bool isInfo;
  final IconData? iconData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isInfo) {
      return Expanded(
        child: Card(
          elevation: 8,
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: fontSizeOf.x1,
              child: TextButton(
                onPressed: isLoading ? null : onTap,
                child: Center(
                  child: Row(
                    children: [
                      if (isLoading) loadingIconWigit,
                      T3(title, color: Colors.white),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: isLoading
                ? loadingIconWigit
                : IconH1(iconData, color: Colors.white),
            onTap: isLoading ? null : onTap,
            title: H2(title, color: Colors.white),
            subtitle:
                subtitle == null ? null : T2(subtitle!, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

void openRetailReport(
  BuildContext context,
  CashCounterDoc cashCounterDoc,
  ProductDoc productDoc,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retail Report Table"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            DisplayTable.fromString(
              titleNames: const ["Name", "Q"],
              data2D: productDoc.codeNums.map((e) {
                final item = productDoc.getItemBy(code: e);
                return [
                  item?.name ?? "--*--",
                  cashCounterDoc.stockConsumed[item?.id]?.text ?? "--"
                ];
              }),
            )
          ],
        ),
      ),
    );
  }));
}

void openCurrentStockReport(
  BuildContext context,
  StockDoc stockDoc,
  ProductDoc productDoc,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Stock Report Table"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            DisplayTable.fromString(
              titleNames: const ["Name", "Q"],
              data2D: productDoc.codeNums.map((e) {
                final item = productDoc.getItemBy(code: e);
                return [
                  item?.name ?? "--*--",
                  stockDoc.currentStock[item?.id]?.text ?? "--"
                ];
              }),
            )
          ],
        ),
      ),
    );
  }));
}

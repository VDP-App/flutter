import 'dart:async';

import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:vdp/documents/utils/product.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/apis/custom/gst_bill.dart';
import 'package:vdp/utils/modal.dart';
import 'package:vdp/utils/random.dart';
import 'package:vdp/utils/typography.dart';
import 'package:intl/intl.dart';

bool get _spaceInOrder => sharedPreferences.getBool("bill-space-item") ?? true;
// bool get _spaceInGst => sharedPreferences.getBool("bill-sapce-gst") ?? true;
void _setSpaceInOrder(bool c) =>
    sharedPreferences.setBool("bill-space-item", c);
// void _setSpaceInGst(bool c) => sharedPreferences.setBool("bill-sapce-gst", c);

final dateFormat = DateFormat("dd/MM/yyyy").format;
final timeFormate = DateFormat.jm().format;

extension on BlueThermalPrinter {
  Future<dynamic> printDivider() {
    return printCustom("".padLeft(42, "*"), 0, 1);
  }

  Future<void> printInit(String billNum, bool isCopy) async {
    await printNewLine();
    await printCustom("VARDAIYINI DAIRY PRODUCTS", 3, 1);
    await printCustom("VINAYAK COMPLEX BAREJA 382425", 1, 1);
    await printLeftRight("DIST.AHMEDABAD", "MO.7201925410", 1);
    await printLeftRight("", "9898021278", 1);
    await printCustom("GSTIN 244ADEPP4838L127", 1, 0);
    await printDivider();
    if (isCopy) {
      final now = DateTime.now();
      await printLeftRight("BILL NO: -${parseCode(billNum)}", "**COPY**", 1);
      await printCustom("DATE:${dateFormat(now)}", 1, 0);
    } else {
      final now = DateTime.now();
      await printCustom("BILL NO: -${parseCode(billNum)}", 1, 0);
      await printLeftRight(
          "DATE:${dateFormat(now)}", "TIME: ${timeFormate(now)}", 1);
    }
    await printDivider();
    await print3Column("ITEM  QTY", "RATE", "AMOUNT", 1,
        format: "%-10s %10s %10s");
    await printDivider();
  }

  Future<void> printOrder(GSTBill gstBill) async {
    final space = _spaceInOrder;
    final formate = space ? "%-10s %10s %10s %n" : "%-10s %10s %10s";
    for (var order in gstBill.bill.orders) {
      await printCustom(order.item.name, 3, 0);
      await print3Column(
        order.quntity.toIntl(p2: false),
        order.rate.toIntl(),
        order.amount.toIntl(),
        3,
        format: formate,
      );
      if (!space) await printNewLine();
    }
    await printDivider();
    await printLeftRight("SUB TOTAL", gstBill.totalAmount.toIntl(), 3);
  }

  Future<void> printTaxes(GSTBill gstBill) async {
    // final space = _spaceInGst;
    // final formate = space ? "%5s %5s %-10s %4s %n" : "%5s %6s %-8s %4s";
    await printLeftRight("TAXABLE RS", gstBill.totalTaxable.toIntl(), 1);
    await printNewLine();
    for (var gst in gstBill.gst.toList()) {
      await print4Column(
        gst.type.name,
        "@ ${gst.gst}",
        gst.taxableAmount.toIntl(),
        gst.tax.toIntl(),
        1,
        // format: formate,
        format: "%5s %5s %-10s %4s %n",
      );
    }
    await printDivider();
    await printLeftRight("TOTAL TAX", gstBill.totalTax.toIntl(), 1);
  }

  Future<void> printSummery(GSTBill gstBill) async {
    await printCustom("ITEMS: ${gstBill.bill.orders.length}", 1, 0);
    await printDivider();
    await printLeftRight(gstBill.bill.inCash ? "CASH" : "G-PAY",
        gstBill.bill.moneyGiven.toIntl(), 1);
    await printLeftRight("TOTAL Rs", gstBill.bill.totalMoney.toIntl(), 3);
    await printNewLine();
    if (gstBill.bill.moneyGiven.val > gstBill.totalAmount.val) {
      await printDivider();
      await printLeftRight("RETURN: ", gstBill.totalAmountReturned.toIntl(), 3);
    }
  }

  Future<void> printConnected() async {
    await printNewLine();
    await printNewLine();

    await printDivider();
    await printNewLine();

    await printCustom("PRINTER CONNECTED", 3, 1);

    await printNewLine();
    await printDivider();

    await printNewLine();
    await printNewLine();
  }

  Future<void> printGreatings(GSTBill gstBill) async {
    await printCustom("THANK YOU", 1, 1);
    await printNewLine();
    await printNewLine();
    await paperCut();
  }
}

final _mapDevices = <String, BluetoothDevice>{};
final _rMapDevices = <BluetoothDevice, ModalListElement>{};

extension on BluetoothDevice {
  ModalListElement toModalListElement() {
    return _rMapDevices[this] ??= () {
      final id = randomString;
      _mapDevices[id] = this;
      return ModalListElement(id: id, name: name ?? "*-/*");
    }();
  }
}

class BlutoothProvider extends Modal with ChangeNotifier {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  StreamSubscription? streamSubscription;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _loading = false;

  bool get loading => _loading;

  String? get device {
    if (!_connected || _device == null) return null;
    return _device?.name ?? "--*--";
  }

  BlutoothProvider(BuildContext context) : super(context) {
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await bluetooth.getBondedDevices().catchError((_) => _devices).then((val) {
      _devices = val;
      if (_device == null) {
        var add = sharedPreferences.getString("printer-address");
        if (add == null) return;
        for (var d in val) {
          if (d.address == add) {
            _device = d;
            _connect();
            break;
          }
        }
      }
    });
    streamSubscription?.cancel();
    streamSubscription = bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          _connected = true;
          _loading = false;
          notifyListeners();
          var add = _device?.address;
          if (add != null) sharedPreferences.setString("printer-address", add);
          openModal(
            "Printer Connected",
            (device ?? "--") + " is connected",
            okText: "TEST",
            onOk: _test,
          );
          break;
        case BlueThermalPrinter.DISCONNECTED:
          _connected = false;
          _loading = false;
          notifyListeners();
          _connect();
          break;
      }
    });
  }

  void _test() async {
    if (!_connected) {
      openModal(
        "No Divice Connected",
        "Select a device for test",
        onOk: selectDevice,
      );
      return;
    }
    final isConnected = await bluetooth.isConnected;
    if (isConnected == null || !isConnected) {
      openModal(
        "Something is Wrong",
        "No Blutooth device found",
        onOk: selectDevice,
      );
      return;
    }
    await bluetooth.printConnected();
  }

  void _disconnect() {
    if (!_connected) return;
    _loading = true;
    notifyListeners();
    bluetooth.disconnect().catchError((_) {});
  }

  void _connect() {
    final device = _device;
    if (device == null) return;
    if (_connected) return;
    _loading = true;
    notifyListeners();
    bluetooth.connect(device).catchError((e) {}).whenComplete(() {
      _loading = false;
      notifyListeners();
    });
  }

  Future<void> printBill(GSTBill gstBill, [bool isCopy = false]) async {
    final isConnected = await bluetooth.isConnected;
    if (isConnected == null || !isConnected) {
      openModal(
        "No Divice Connected",
        "Select a device for Billing",
        onOk: () {
          selectDevice();
        },
        okText: "Select",
      );
      return;
    }
    await bluetooth.printInit(gstBill.bill.billNum, isCopy);
    await bluetooth.printOrder(gstBill);
    await bluetooth.printTaxes(gstBill);
    await bluetooth.printSummery(gstBill);
    await bluetooth.printGreatings(gstBill);
  }

  void selectDevice() async {
    if (_loading) return;
    final id = await selectOne<ModalListElement>(
      title: "Select Blutooth Device",
      currentlySelected: _device?.toModalListElement(),
      modalListElement: _devices.map((e) => e.toModalListElement()),
      onSelect: (_) {},
    );
    final device = _mapDevices[id];
    if (device == null || _device == device) return;
    if (_connected || await bluetooth.isConnected == true) {
      _disconnect();
      _device = device;
    } else {
      _device = device;
      _connect();
    }
  }

  void changeOptions() {
    launchWidgit(context, "Print Setting", const _Options());
  }

  @override
  void dispose() {
    _disconnect();
    streamSubscription?.cancel();
    super.dispose();
  }
}

class _Options extends StatefulWidget {
  const _Options({
    Key? key,
  }) : super(key: key);

  @override
  State<_Options> createState() => _OptionsState();
}

class _OptionsState extends State<_Options> {
  var spaceInOrder = _spaceInOrder;
  // var spaceInGst = _spaceInGst;

  void setSpaceInOrder(bool c) {
    setState(() {
      spaceInOrder = c;
    });
    _setSpaceInOrder(c);
  }

  // void setSpaceInGst(bool c) {
  //   setState(() {
  //     spaceInGst = c;
  //   });
  //   _setSpaceInGst(c);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const T1("New Line in Order Section"),
        Switch(value: spaceInOrder, onChanged: setSpaceInOrder),
        const SizedBox(height: 10),
        // const Divider(),
        // const SizedBox(height: 10),
        // const T1("Space in Gst Section"),
        // Switch(value: spaceInGst, onChanged: setSpaceInGst)
      ],
    );
  }
}

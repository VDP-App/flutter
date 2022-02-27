import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/sorted_list.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

enum GstType { sgst, cgst }

extension Utility on GstType {
  String get name {
    if (this == GstType.sgst) return "SGST";
    if (this == GstType.cgst) return "CGST";
    return "--";
  }
}

class GST {
  // gst%
  final double gst;
  int taxableAmount = 0;

  GST(this.gst);

  FixedGST toFixedGST(GstType type) {
    return FixedGST(
      type,
      gst: gst,
      taxableAmount: FixedNumber.fromInt(taxableAmount),
      // C*gst%/100
      tax: FixedNumber.fromInt(taxableAmount * gst ~/ 100),
    );
  }
}

class FixedGST extends CompareClass<FixedGST> {
  // gst%
  final double gst;
  final GstType type;
  final FixedNumber taxableAmount;
  final FixedNumber tax;

  FixedGST(
    this.type, {
    required this.gst,
    required this.taxableAmount,
    required this.tax,
  });

  @override
  Comparator compare(FixedGST e) {
    if (gst == e.gst) return Comparator.isEqual;
    if (gst > e.gst) return Comparator.isGreater;
    return Comparator.isLess;
  }
}

void _addTax(FixedNumber amount, GST sgst, GST cgst) {
  // C = T*10000/(100 + s%)(100 + c%)
  final taxableAmount =
      amount.val * 10000 ~/ ((100 + sgst.gst) * (100 + cgst.gst));
  sgst.taxableAmount += taxableAmount;
  cgst.taxableAmount += taxableAmount;
}

class GSTBill {
  final Bill bill;
  final gst = SortedList<FixedGST>();
  late final FixedNumber totalTax;
  late final FixedNumber totalTaxable;
  late final FixedNumber totalAmount;
  late final FixedNumber totalAmountReturned;

  GSTBill(this.bill) {
    totalAmount = bill.totalMoney;
    totalAmountReturned = FixedNumber.fromInt(bill.moneyGiven - totalAmount);
    final cgst = <double, GST>{};
    final sgst = <double, GST>{};
    for (var order in bill.orders) {
      final item = order.item;
      _addTax(
        order.amount,
        sgst[item.sgst] ??= GST(item.sgst),
        cgst[item.cgst] ??= GST(item.cgst),
      );
    }
    var _totalTax = 0;
    var _totalTaxable = 0;
    gst.customAdd<GST>(cgst.values, (_gst) {
      _totalTaxable += _gst.taxableAmount;
      if (_gst.gst == 0) return null;
      final fixedGST = _gst.toFixedGST(GstType.cgst);
      _totalTax += fixedGST.tax.val;
      return fixedGST;
    });
    gst.customAdd<GST>(sgst.values, (_gst) {
      if (_gst.gst == 0) return null;
      final fixedGST = _gst.toFixedGST(GstType.sgst);
      _totalTax += fixedGST.tax.val;
      return fixedGST;
    });
    totalTax = FixedNumber.fromInt(_totalTax);
    totalTaxable = FixedNumber.fromInt(_totalTaxable);
  }
}

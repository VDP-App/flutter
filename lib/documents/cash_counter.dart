import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/providers/make_entries/custom/number.dart';

class CashCounterDoc {
  final List<Bill> bills;
  final FixedNumber onlineIncome;
  final FixedNumber offlineIncome;
  final Map<String, FixedNumber> stockConsumed;
  const CashCounterDoc(
    this.bills,
    this.offlineIncome,
    this.onlineIncome,
    this.stockConsumed,
  );

  factory CashCounterDoc.fromJson(Map<String, dynamic> data) {
    final income = asMap(data["income"]);
    final bills = <Bill>[];
    final stockConsumed = <String, int>{};

    for (var rawBill in asList(data["bills"])) {
      var bill = Bill.fromJson(rawBill);
      for (var order in bill.orders) {
        stockConsumed[order.itemId] =
            (stockConsumed[order.itemId] ?? 0) + order.quntity.val;
      }
      bills.insert(0, bill);
    }
    return CashCounterDoc(
      bills,
      FixedNumber.fromInt(asInt(income["offline"])),
      FixedNumber.fromInt(asInt(income["online"])),
      stockConsumed.map((key, i) => MapEntry(key, FixedNumber.fromInt(i))),
    );
  }

  FixedNumber get totalIncome {
    return FixedNumber.fromInt(onlineIncome.val + offlineIncome.val);
  }
}

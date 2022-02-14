import 'package:vdp/documents/utils/bill.dart';
import 'package:vdp/documents/utils/parsing.dart';
import 'package:vdp/documents/utils/sorted_list.dart';
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
    return CashCounterDoc(
      SortedList<Bill>(
        inAscending: false,
      ).customAdd<MapEntry<String, dynamic>>(
        asMap(data["bills"]).entries,
        (x) => Bill.fromMapEntry(x),
      ),
      FixedNumber.fromInt(asInt(income["offline"])),
      FixedNumber.fromInt(asInt(income["online"])),
      asMap(data["stockConsumed"]).map(
          (key, value) => MapEntry(key, FixedNumber.fromInt(asInt(value)))),
    );
  }

  FixedNumber get totalIncome {
    return FixedNumber.fromInt(onlineIncome.val + offlineIncome.val);
  }
}

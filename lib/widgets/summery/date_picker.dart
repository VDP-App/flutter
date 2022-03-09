import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/providers/doc/summerize.dart';
import 'package:vdp/widgets/summery/card_button.dart';

class PickDate extends StatelessWidget {
  const PickDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summerize = Provider.of<Summerize>(context);
    return CardButton(
      iconData: summerize.dateTimeRange == null
          ? Icons.warning
          : Icons.date_range_rounded,
      title: summerize.dateTimeRangeInShort ?? "Select Date!!",
      subtitle: "Tap to Change Date",
      color: Colors.black,
      onTap: () => _launchDateRangePicker(
        context,
        summerize.dateTimeRange,
        summerize.changeDate,
      ),
    );
  }
}

void _launchDateRangePicker(
  BuildContext context,
  DateTimeRange? initialDateRange,
  void Function(DateTimeRange dateTime) onChange,
) {
  final yesterday = DateTime.now().add(const Duration(days: -1, minutes: -10));
  showDateRangePicker(
    context: context,
    initialDateRange: initialDateRange ??
        DateTimeRange(
          start: yesterday,
          end: yesterday,
        ),
    firstDate: DateTime(2022, 02, 14),
    lastDate: yesterday,
  ).then((value) {
    if (value != null) onChange(value);
  });
}

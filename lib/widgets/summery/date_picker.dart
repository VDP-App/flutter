import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdp/providers/doc/summery.dart';
import 'package:vdp/widgets/summery/card_button.dart';

class PickDate extends StatelessWidget {
  const PickDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summery = Provider.of<Summery>(context);
    return CardButton(
      iconData: summery.date == null ? Icons.warning : Icons.date_range_rounded,
      title: summery.dateInString ?? "Select Date!!",
      subtitle: "Tap to Change Date",
      color: Colors.black,
      onTap: () => _launchDatePicker(context, summery.date, summery.changeDate),
      isLoading: summery.isEmpty == null,
    );
  }
}

void _launchDatePicker(
  BuildContext context,
  DateTime? initialDate,
  void Function(DateTime dateTime) onChange,
) {
  final yesterday = DateTime.now().add(const Duration(days: -1, minutes: -10));
  showDatePicker(
    context: context,
    initialDate: initialDate ?? yesterday,
    firstDate: DateTime(2022, 02, 14),
    lastDate: yesterday,
  ).then((value) {
    if (value != null) onChange(value);
  });
}

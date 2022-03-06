import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/location.dart';
import 'package:vdp/utils/typography.dart';

class SelectLocationButton extends StatelessWidget {
  const SelectLocationButton({
    Key? key,
    required this.action,
    required this.title,
    required this.text,
  }) : super(key: key);
  final String title;
  final String text;
  final void Function() action;

  factory SelectLocationButton.fromLocation(Location location, String title) {
    if (location.stockID == null) {
      return SelectLocationButton(
        action: location.selectStock,
        title: title,
        text: "Select Stock",
      );
    }
    return SelectLocationButton(
      action: location.selectCashCounter,
      title: title,
      text: "Select Cash Counter",
    );
  }

  @override
  Widget build(BuildContext context) {
    final spaceHight = (MediaQuery.of(context).size.height) / 5;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          SizedBox(height: spaceHight),
          Center(child: H2(title)),
          ElevatedButton(
            child: H1(text),
            onPressed: action,
          ),
        ],
      ),
    );
  }
}

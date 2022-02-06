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
    return Center(
      child: Column(
        children: [
          H2(title),
          const SizedBox(height: 50),
          ElevatedButton(
            child: H1(text),
            onPressed: action,
          ),
          const SizedBox(height: 200),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

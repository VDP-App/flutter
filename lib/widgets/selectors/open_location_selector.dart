import 'package:flutter/material.dart';
import 'package:vdp/providers/apis/location.dart';

class SelectLocationButton extends StatelessWidget {
  const SelectLocationButton({
    Key? key,
    required this.action,
    required this.title,
  }) : super(key: key);
  final String title;
  final void Function() action;

  factory SelectLocationButton.fromLocation(Location location) {
    if (location.stockID == null) {
      return SelectLocationButton(
        action: location.selectStock,
        title: "Select Stock",
      );
    }
    return SelectLocationButton(
      action: location.selectCashCounter,
      title: "Select Cash Counter",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("To Make an entry", style: TextStyle(fontSize: 60)),
          const SizedBox(height: 50),
          ElevatedButton(
            child: Text(title, style: const TextStyle(fontSize: 50)),
            onPressed: action,
          ),
          const SizedBox(height: 200),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

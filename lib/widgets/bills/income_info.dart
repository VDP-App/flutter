import 'package:flutter/material.dart';
import 'package:vdp/utils/loading.dart';

enum CashIn { offline, online }

class IncomeInfo extends StatelessWidget {
  const IncomeInfo({
    Key? key,
    required this.amount,
    required this.cashIn,
  }) : super(key: key);
  final CashIn cashIn;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final isOffline = cashIn == CashIn.offline;
    return Expanded(
      child: Card(
        elevation: 8,
        shadowColor: Colors.deepPurpleAccent,
        color: Colors.deepPurple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      isOffline ? "Offline" : "Online",
                      style: const TextStyle(fontSize: 45, color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                      child: Text(
                        rs_ + amount,
                        style: const TextStyle(
                            fontSize: 40, color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                      "images/${isOffline ? "cash" : "google-pay-icon"}.png"),
                  radius: 50,
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

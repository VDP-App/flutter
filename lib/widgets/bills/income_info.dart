import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

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
                    T3(isOffline ? "Offline" : "Online", color: Colors.white),
                    SizedBox(
                      height: fontSizeOf.h1,
                      child: T2(rs_ + amount, color: Colors.white70),
                    )
                  ],
                ),
              ),
            ),
            if (isTablet)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                        "images/${isOffline ? "cash" : "google-pay-icon"}.png"),
                    radius: fontSizeOf.h1,
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

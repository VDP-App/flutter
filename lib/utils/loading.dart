import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/typography.dart';

const rs = "₹";
const rs_ = "₹ ";

class NoData extends StatelessWidget {
  const NoData({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final spaceHight = (MediaQuery.of(context).size.height) * 2 / 5;
    return ListView(
      children: [
        SizedBox(height: spaceHight),
        const IconX1(Icons.search_off_rounded, color: Colors.grey),
        SizedBox(
          width: double.infinity,
          child: Center(
            child: H2(text, color: Colors.pink),
          ),
        ),
      ],
    );
  }
}

final loadingWigit = Center(
  child: SizedBox.square(
    dimension: fontSizeOf.x1,
    child: const FittedBox(
      fit: BoxFit.contain,
      child: CircularProgressIndicator(
        semanticsLabel: 'Circular progress indicator',
      ),
    ),
  ),
);

const loadingWigitLinier = LinearProgressIndicator(
  semanticsLabel: 'Linear progress indicator',
);

final loadingIconWigit = Center(
  child: SizedBox.square(
    dimension: fontSizeOf.t1,
    child: const FittedBox(
      fit: BoxFit.contain,
      child: CircularProgressIndicator(
        semanticsLabel: 'Circular Icon progress indicator',
        color: Colors.white,
      ),
    ),
  ),
);

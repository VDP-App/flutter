import 'package:flutter/material.dart';

const rs = "₹";
const rs_ = "₹ ";

class NoData extends StatelessWidget {
  const NoData({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 10),
        const Icon(
          Icons.search_off_rounded,
          size: 100,
          color: Colors.grey,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 55, color: Colors.pink),
            ),
          ),
        ),
        const Spacer(flex: 20),
      ],
    );
  }
}

const loadingWigit = Center(
  child: SizedBox.square(
    dimension: 100,
    child: FittedBox(
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

const loadingIconWigit = Center(
  child: SizedBox.square(
    dimension: 35,
    child: FittedBox(
      fit: BoxFit.contain,
      child: CircularProgressIndicator(
        semanticsLabel: 'Circular Icon progress indicator',
        color: Colors.white,
      ),
    ),
  ),
);

import 'package:flutter/material.dart';
import 'package:vdp/utils/typography.dart';

class GridItem {
  final String title;
  final void Function() onPress;

  GridItem({required this.onPress, required this.title});
}

class GridSelector extends StatelessWidget {
  const GridSelector(
      {Key? key,
      required this.builder,
      required this.count,
      required this.length,
      required this.color})
      : super(key: key);
  final int count;
  final int length;
  final Color color;
  final GridItem Function(int index) builder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: List.generate(length, (index) {
          var gridItem = builder(index);
          return SizedBox.expand(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: color,
              ),
              child: FractionallySizedBox(
                child: T2(
                  gridItem.title,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
              onPressed: gridItem.onPress,
            ),
          );
        }),
      ),
    );
  }
}

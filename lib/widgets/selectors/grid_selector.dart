import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/typography.dart';

class GridItem {
  final String title;
  final void Function() onPress;
  final Color? color;

  GridItem({required this.onPress, required this.title, this.color});
}

class GridSelector extends StatelessWidget {
  const GridSelector({
    Key? key,
    required this.builder,
    required this.count,
    required this.length,
    required this.color,
  }) : super(key: key);
  final int count;
  final int length;
  final Color color;
  final GridItem Function(int index) builder;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: isTablet ? const EdgeInsets.all(15) : const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: size.width < size.height ? 3 : 5,
        mainAxisSpacing: isTablet ? 20 : 8,
        crossAxisSpacing: isTablet ? 20 : 8,
        children: List.generate(length, (index) {
          var gridItem = builder(index);
          return SizedBox.expand(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: gridItem.color ?? color,
              ),
              child: FractionallySizedBox(
                child: isTablet
                    ? T2(
                        gridItem.title,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      )
                    : T1(
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

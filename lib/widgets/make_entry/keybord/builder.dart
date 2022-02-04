import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum KeybordKeyValue {
  num0,
  num1,
  num2,
  num3,
  num4,
  num5,
  num6,
  num7,
  num8,
  num9,
  period,
  esc,
  enter,
  action1,
  action2,
  action3,
}

extension Num on KeybordKeyValue {
  String? get num {
    var str = toString();
    if (str.contains("num")) return str[str.length - 1];
    return null;
  }
}

class KeybordKey extends StatelessWidget {
  const KeybordKey({
    Key? key,
    required this.keyValue,
    required this.text,
    this.icon,
    this.color,
    this.flex = 1,
  }) : super(key: key);
  final KeybordKeyValue keyValue;
  final String text;
  final IconData? icon;
  final Color? color;
  final int flex;

  @override
  Widget build(BuildContext context) {
    var act = Provider.of<void Function(KeybordKeyValue)>(context);
    return Flexible(
      flex: flex,
      child: TextButton(
        onPressed: () => act(keyValue),
        style: TextButton.styleFrom(
          backgroundColor: icon != null ? Colors.black : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: color == null ? 25 : 30,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
        ),
      ),
    );
  }
}

class KeybordBuilder extends StatelessWidget {
  const KeybordBuilder({
    Key? key,
    required this.act,
    required this.actions,
  }) : super(key: key);

  final List<KeybordKey> actions;
  final void Function(KeybordKeyValue) act;

  @override
  Widget build(BuildContext context) {
    List<List<KeybordKey>> keys = [
      [
        const KeybordKey(
          keyValue: KeybordKeyValue.esc,
          text: "Esc",
          icon: Icons.restart_alt_rounded,
        ),
        ...actions
      ],
      const [
        KeybordKey(keyValue: KeybordKeyValue.num1, text: "1"),
        KeybordKey(keyValue: KeybordKeyValue.num4, text: "4"),
        KeybordKey(keyValue: KeybordKeyValue.num7, text: "7"),
        KeybordKey(
          keyValue: KeybordKeyValue.period,
          text: "M.",
          color: Colors.pink,
        ),
      ],
      const [
        KeybordKey(keyValue: KeybordKeyValue.num2, text: "2"),
        KeybordKey(keyValue: KeybordKeyValue.num5, text: "5"),
        KeybordKey(keyValue: KeybordKeyValue.num8, text: "8"),
        KeybordKey(keyValue: KeybordKeyValue.num0, text: "0"),
      ],
      const [
        KeybordKey(keyValue: KeybordKeyValue.num3, text: "3"),
        KeybordKey(keyValue: KeybordKeyValue.num6, text: "6"),
        KeybordKey(keyValue: KeybordKeyValue.num9, text: "9"),
        KeybordKey(
          keyValue: KeybordKeyValue.enter,
          text: "enter",
          icon: Icons.keyboard_return,
        ),
      ],
    ];
    return Provider(
      create: (_) => act,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys
            .map((keyList) => Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: keyList,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

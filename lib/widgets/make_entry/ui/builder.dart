import 'package:flutter/material.dart';
import 'package:vdp/utils/typography.dart';

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
    required this.act,
    this.icon,
    this.color,
    this.flex = 1,
  }) : super(key: key);
  final KeybordKeyValue keyValue;
  final String text;
  final IconData? icon;
  final Color? color;
  final int flex;
  final void Function(KeybordKeyValue) act;

  @override
  Widget build(BuildContext context) {
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
              ? IconT2(icon, color: Colors.white)
              : color == null
                  ? P2(text, fontWeight: FontWeight.bold, color: color)
                  : P3(text, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}

class UIBuilder extends StatelessWidget {
  const UIBuilder({
    Key? key,
    required this.act,
    required this.actions,
    required this.child,
  }) : super(key: key);

  final List<KeybordKey> actions;
  final void Function(KeybordKeyValue) act;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final actionKeys = [
      KeybordKey(
        act: act,
        keyValue: KeybordKeyValue.esc,
        text: "Esc",
        icon: Icons.undo_rounded,
      ),
      ...actions
    ];
    final keys = [
      Flexible(
        fit: FlexFit.tight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeybordKey(act: act, keyValue: KeybordKeyValue.num7, text: "7"),
            KeybordKey(act: act, keyValue: KeybordKeyValue.num4, text: "4"),
            KeybordKey(act: act, keyValue: KeybordKeyValue.num1, text: "1"),
            KeybordKey(
              act: act,
              keyValue: KeybordKeyValue.period,
              text: "M.",
              color: Colors.pink,
            ),
          ],
        ),
      ),
      Flexible(
        fit: FlexFit.tight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeybordKey(act: act, keyValue: KeybordKeyValue.num8, text: "8"),
            KeybordKey(act: act, keyValue: KeybordKeyValue.num5, text: "5"),
            KeybordKey(act: act, keyValue: KeybordKeyValue.num2, text: "2"),
            KeybordKey(act: act, keyValue: KeybordKeyValue.num0, text: "0"),
          ],
        ),
      ),
      Flexible(
        fit: FlexFit.tight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeybordKey(act: act, keyValue: KeybordKeyValue.num9, text: "9"),
            KeybordKey(act: act, keyValue: KeybordKeyValue.num6, text: "6"),
            KeybordKey(act: act, keyValue: KeybordKeyValue.num3, text: "3"),
            KeybordKey(
              act: act,
              keyValue: KeybordKeyValue.enter,
              text: "enter",
              icon: Icons.keyboard_return,
            ),
          ],
        ),
      ),
    ];
    final size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      return Row(
        children: [
          Flexible(
            child: Column(
              children: [
                Flexible(child: child, flex: 3),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: actionKeys,
                  ),
                ),
              ],
            ),
            flex: 2,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: keys,
              ),
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      );
    }
    return Column(
      children: [
        Flexible(child: child, flex: 3, fit: FlexFit.tight),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: actionKeys,
                ),
              ),
              ...keys,
            ],
          ),
          flex: 5,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

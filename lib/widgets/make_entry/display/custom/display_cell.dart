import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'cursor.dart';
import 'display_widgit.dart';

class DisplayCell extends StatelessWidget {
  const DisplayCell({
    Key? key,
    this.value = "",
    this.lable = "",
    this.active = false,
    this.widget,
    this.flex = 1,
    this.onClick,
  }) : super(key: key);

  final String lable;
  final String value;
  final bool active;
  final Widget? widget;
  final int flex;
  final void Function()? onClick;

  Widget activeWidget() {
    String? val, chr;
    if (value.length == 1) {
      chr = value;
    } else if (value.length > 1) {
      chr = value.characters.last;
      val = value.substring(0, value.length - 1);
    }
    return Row(
      children: [
        if (val != null)
          DisplayText(
            Text(
              val,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "PTSans",
              ),
            ),
            bgColor: Colors.purple,
          ),
        Cursor(lastChar: chr ?? " "),
      ],
    );
  }

  Widget unactiveWidget() {
    return DisplayText(
      Text(
        value,
        style: const TextStyle(
          color: Colors.black87,
          fontFamily: "PTSans",
        ),
      ),
      bgColor: Colors.amber,
    );
  }

  Widget lableWidget() {
    return DisplayText(
      Text(
        "$lable: ",
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _widget = Row(
      children: [
        if (lable.isNotEmpty) lableWidget(),
        if (widget != null) Expanded(child: widget!),
        if (value.isNotEmpty || active)
          Flexible(
            child: active ? activeWidget() : unactiveWidget(),
          ),
      ],
    );
    return Expanded(
      flex: flex,
      child: onClick == null
          ? _widget
          : isTablet
              ? TextButton(
                  onPressed: onClick,
                  child: _widget,
                )
              : GestureDetector(
                  child: _widget,
                  onTap: onClick,
                ),
    );
  }
}

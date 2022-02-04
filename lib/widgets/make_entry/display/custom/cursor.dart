import 'package:flutter/material.dart';
import 'display_widgit.dart';
import 'dart:async';

class Cursor extends StatefulWidget {
  const Cursor({Key? key, required this.lastChar}) : super(key: key);

  final String lastChar;

  @override
  _CursorState createState() => _CursorState();
}

class _CursorState extends State<Cursor> {
  bool show = true;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 600),
      (_) => setState(() => show = !show),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DisplayText(
      Text(
        widget.lastChar.isEmpty ? " " : widget.lastChar,
        style: TextStyle(
          color: show ? Colors.white : null,
          fontFamily: "PTSans",
          letterSpacing: 2,
        ),
      ),
      bgColor: show ? Colors.deepPurple : null,
    );
  }
}

import 'package:vdp/providers/make_entries/custom/formate.dart';

abstract class NumClass {
  int get val;
  String get text;
  const NumClass();

  int operator -(NumClass n) => val - n.val;
  int operator +(NumClass n) => val + n.val;
  int operator /(NumClass n) => n.val == 0 ? 0 : (1000 * val ~/ n.val);
}

class Number extends NumClass {
  String _text = "";
  int _val = 0;

  @override
  int get val => _val;
  @override
  String get text => _text;
  bool get isEmpty => _text.isEmpty;
  bool get isNotEmpty => _text.isNotEmpty;

  void _formate() {
    _text = formate(_val / 1000);
  }

  void _parse() {
    _val = (double.parse(_text.replaceAll(",", "")) * 1000).toInt();
  }

  void assign(NumClass n) {
    _text = n.text;
    _val = n.val;
  }

  int get _periodAt => _text.indexOf(".");

  String? get _trailingNum {
    final i = _periodAt;
    if (i >= 0) return _text.substring(i);
    return null;
  }

  bool periodPress() {
    if (_periodAt >= 0) return true;
    _text += ".";
    return false;
  }

  void negate() {
    if (_text.startsWith("-")) {
      _text = _text.substring(1);
    } else {
      _text = "-$_text";
    }
    _val = -val;
  }

  void appendDigit(String digit) {
    final trailingNum = _trailingNum;
    if (trailingNum == null) {
      _text += digit;
      _parse();
      _formate();
    } else if (trailingNum.length <= 3) {
      _text += digit;
      _parse();
    }
  }

  set val(int x) {
    if (x == 0) {
      _val = 0;
      _text = "";
    } else {
      _val = x;
      _formate();
    }
  }

  @override
  String toString() => {"text": _text, "val": _val}.toString();

  FixedNumber toFixedNumber() => FixedNumber(text: _text, val: _val);
}

class FixedNumber extends NumClass {
  @override
  final String text;
  @override
  final int val;
  const FixedNumber({required this.text, required this.val});

  factory FixedNumber.fromDouble(double d) {
    return FixedNumber(text: formate(d), val: (d * 1000).toInt());
  }

  factory FixedNumber.fromInt(int i) {
    return FixedNumber(text: formate(i / 1000), val: i);
  }

  @override
  String toString() => text;
}

import 'package:flutter/material.dart';
import 'package:vdp/main.dart';

abstract class TypoText extends StatelessWidget {
  const TypoText({Key? key}) : super(key: key);
}

abstract class TypoIcon extends StatelessWidget {
  const TypoIcon({Key? key}) : super(key: key);
}

class P1 extends TypoText {
  const P1(this.text, {Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSizeOf.p1), key: key);
  }
}

class P2 extends TypoText {
  const P2(
    this.text, {
    Key? key,
    this.color,
    this.fontWeight,
  }) : super(key: key);
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSizeOf.p2,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

class P3 extends TypoText {
  const P3(
    this.text, {
    Key? key,
    this.color,
    this.fontWeight,
  }) : super(key: key);
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSizeOf.p3,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  static Text bigger(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: fontSizeOf.p3 + 3),
    );
  }
}

class T1 extends TypoText {
  const T1(this.text, {Key? key, this.color, this.textAlign}) : super(key: key);
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSizeOf.t1, color: color),
      textAlign: textAlign,
    );
  }
}

class T2 extends TypoText {
  const T2(this.text, {Key? key, this.color, this.textAlign}) : super(key: key);
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSizeOf.t2, color: color),
      textAlign: textAlign,
    );
  }
}

class T3 extends TypoText {
  const T3(this.text, {Key? key, this.color, this.fontFamily})
      : super(key: key);
  final Color? color;
  final String text;
  final String? fontFamily;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSizeOf.t3,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }
}

class H1 extends TypoText {
  const H1(this.text, {Key? key, this.color}) : super(key: key);
  final Color? color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSizeOf.h1, color: color));
  }
}

class H2 extends TypoText {
  const H2(this.text, {Key? key, this.color}) : super(key: key);
  final Color? color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSizeOf.h2, color: color));
  }
}

class IconP3 extends TypoIcon {
  const IconP3(this.icon, {Key? key, this.color}) : super(key: key);
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: fontSizeOf.p3, color: color);
  }

  static Icon bigger(IconData? icon, {Color? color}) {
    return Icon(
      icon,
      color: color,
      size: fontSizeOf.p3 + 3,
    );
  }
}

class IconT1 extends TypoIcon {
  const IconT1(this.icon, {Key? key, this.color}) : super(key: key);
  final Color? color;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: fontSizeOf.t1, color: color);
  }
}

class IconT2 extends TypoIcon {
  const IconT2(this.icon, {Key? key, this.color}) : super(key: key);
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: fontSizeOf.t2, color: color);
  }
}

class IconT3 extends TypoIcon {
  const IconT3(this.icon, {Key? key, this.color}) : super(key: key);
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: fontSizeOf.t3, color: color);
  }
}

class IconH1 extends TypoIcon {
  const IconH1(this.icon, {Key? key, this.color}) : super(key: key);
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: fontSizeOf.h1, color: color);
  }
}

class IconX1 extends TypoIcon {
  const IconX1(this.icon, {Key? key, this.color}) : super(key: key);
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: fontSizeOf.x1, color: color);
  }
}

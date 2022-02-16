import 'package:flutter/material.dart';
import 'package:vdp/layout.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/typography.dart';

class InfoCell extends StatelessWidget {
  const InfoCell(this.lable, this.info, {Key? key}) : super(key: key);
  final String lable;
  final String? info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          P3("$lable:", color: Colors.purple),
          P3(info ?? "-- * --"),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    this.defaultValue,
    required this.onChange,
    required this.lable,
    this.asInt = false,
  }) : super(key: key);
  final String? defaultValue;
  final void Function(String string) onChange;
  final String lable;
  final bool asInt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        controller: TextEditingController(text: defaultValue),
        style: TextStyle(fontSize: fontSizeOf.t2),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
        ),
        onChanged: onChange,
        keyboardType: asInt ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: P3(title, fontWeight: FontWeight.w500, color: Colors.purple),
    );
  }
}

class BuildPageBody extends StatelessWidget {
  const BuildPageBody({
    Key? key,
    required this.children,
    required this.topic,
    required this.wrapScaffold,
    this.badge,
    this.trailing,
    this.floatingActionButton,
  }) : super(key: key);

  final String topic;
  final Widget? floatingActionButton;
  final bool wrapScaffold;
  final Widget? badge;
  final List<Widget> children;
  final List<Widget>? trailing;

  @override
  Widget build(BuildContext context) {
    final _list = [if (badge != null) badge!, const SizedBox(height: 20)];
    for (var widget in children) {
      _list.add(widget);
      _list.add(const SizedBox(height: 20));
    }
    final _trailing = trailing;
    if (_trailing != null) {
      for (var widget in _trailing) {
        _list.add(widget);
        _list.add(const SizedBox(height: 30));
      }
    }
    if (wrapScaffold) {
      return Scaffold(
        appBar: AppBar(title: appBarTitle(topic)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: _list),
        ),
        floatingActionButton: floatingActionButton,
      );
    }
    return ListView(children: _list);
  }
}

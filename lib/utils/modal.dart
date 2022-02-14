import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/typography.dart';

class ModalListElement {
  final String id;
  final String name;

  const ModalListElement({
    required this.id,
    required this.name,
  });

  Widget toWidget(void Function() onClick, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: isTablet
          ? const EdgeInsets.symmetric(horizontal: 10)
          : const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Colors.grey : null,
        ),
        child: T2(name),
        onPressed: onClick,
      ),
    );
  }
}

Future<String?> launchModal(
  BuildContext context,
  Widget title,
  Widget content,
  List<Widget> Function(BuildContext context) actionButtons,
) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;
      return AlertDialog(
        title: title,
        content: Container(
          width: width - 50,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: content,
        ),
        actions: actionButtons(context),
      );
    },
  );
}

class Modal {
  final BuildContext context;

  Modal(this.context);

  Future<String?> getName(String title, [String? defaultName]) {
    final controller = TextEditingController(text: defaultName);
    return launchModal(
      context,
      T3(title),
      TextField(
        controller: controller,
        style: TextStyle(fontSize: isTablet ? fontSizeOf.t2 : fontSizeOf.t1),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Name",
        ),
      ),
      (context) => [
        TextButton(
          onPressed: () {
            Navigator.pop(context, controller.text);
          },
          child: const P2('Done'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const P2('Back'),
        ),
      ],
    );
  }

  Future<String?> selectOne<T extends ModalListElement>({
    required String title,
    required T? currentlySelected,
    required List<T> modalListElement,
    required void Function(T) onSelect,
  }) {
    final children = <Widget>[];
    for (var e in modalListElement) {
      children.add(e.toWidget(() {
        Navigator.pop(context, e.id);
        onSelect(e);
      }, e.id == currentlySelected?.id));
      children.add(const SizedBox(height: 25));
    }
    return launchModal(
      context,
      T3("Select one of the below $title"),
      ListView(children: children),
      (context) => [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const P2('Back'),
        ),
      ],
    );
  }

  Future<void> handleCloudCall<T>(
    Future<T> future, [
    void Function(T val)? then,
  ]) async {
    try {
      final val = await future;
      then?.call(val);
    } on CloudError catch (cloudError) {
      await openModal(cloudError.code + " ", cloudError.message + " ");
    }
  }

  Future<bool> shouldProceed(String question) {
    return launchModal(
      context,
      H1(question),
      const T3("Go Ahead:"),
      (context) => [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const T1('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, "Yes"),
          child: const T1('Yes'),
        ),
      ],
    ).then((value) => value == "Yes");
  }

  Future<void> openModal(
    String title,
    String content, {
    void Function()? onOk,
    String? okText,
  }) {
    return launchModal(
      context,
      P3(title),
      P2(content),
      (context) => [
        if (onOk != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const P2('Back'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onOk?.call();
          },
          child: P2(okText ?? 'OK!'),
        ),
      ],
    );
  }
}

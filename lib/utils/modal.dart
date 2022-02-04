import 'package:flutter/material.dart';
import 'package:vdp/utils/cloud_functions.dart';

class ModalListElement {
  final String id;
  final String name;

  const ModalListElement({
    required this.id,
    required this.name,
  });

  Widget toWidget(void Function() onClick, bool isSelected) {
    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Colors.grey : null,
        ),
        child: Text(
          name,
          style: const TextStyle(fontSize: 40),
        ),
        onPressed: onClick,
      ),
    );
  }
}

Future<String?> launchModal(
  BuildContext context,
  Widget Function(BuildContext context) title,
  Widget Function(BuildContext context) content,
  List<Widget> Function(BuildContext context) actionButtons,
) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: title(context),
      content: content(context),
      actions: actionButtons(context),
    ),
  );
}

class Modal {
  final BuildContext context;

  Modal(this.context);

  Future<String?> getName(String title, [String? defaultName]) {
    final controller = TextEditingController(text: defaultName);
    return launchModal(
      context,
      (context) => Text(
        title,
        style: const TextStyle(fontSize: 45),
      ),
      (context) {
        var width = MediaQuery.of(context).size.width;
        return Container(
          width: width - 50,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 40),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
          ),
        );
      },
      (context) => [
        TextButton(
          onPressed: () {
            Navigator.pop(context, controller.text);
          },
          child: const Text('Done', style: TextStyle(fontSize: 25)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back', style: TextStyle(fontSize: 25)),
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
    return launchModal(
      context,
      (context) => Text(
        "Select one of the below $title",
        style: const TextStyle(fontSize: 45),
      ),
      (context) {
        final children = <Widget>[];
        for (var e in modalListElement) {
          children.add(e.toWidget(() {
            Navigator.pop(context, e.id);
            onSelect(e);
          }, e.id == currentlySelected?.id));
          children.add(const SizedBox(height: 25));
        }
        return Column(children: children);
      },
      (context) => [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back', style: TextStyle(fontSize: 25)),
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

  Future<bool> shouldProceed() {
    return launchModal(
      context,
      (context) => const Text(
        "Do You Want to Proceed",
        style: TextStyle(fontSize: 50),
      ),
      (context) => const Text(
        "Go Ahead:",
        style: TextStyle(fontSize: 45),
      ),
      (context) => [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No', style: TextStyle(fontSize: 35)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, "Yes"),
          child: const Text('Yes', style: TextStyle(fontSize: 35)),
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
      (context) => Text(title, style: const TextStyle(fontSize: 30)),
      (context) => Text(content, style: const TextStyle(fontSize: 25)),
      (context) => [
        if (onOk != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back', style: TextStyle(fontSize: 25)),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onOk?.call();
          },
          child: Text(okText ?? 'OK!', style: const TextStyle(fontSize: 25)),
        ),
      ],
    );
  }
}

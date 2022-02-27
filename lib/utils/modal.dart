import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/cloud_functions.dart';
import 'package:vdp/utils/typography.dart';

Future<String?> launchModal(
  BuildContext context,
  Widget title,
  Widget content,
  List<ModalButton> actionButtons, [
  bool asBootomDrawer = false,
  bool isScrollControlled = false,
]) {
  if (asBootomDrawer) {
    return showModalBottomSheet<String>(
      isScrollControlled: isScrollControlled,
      context: context,
      builder: (context) {
        var height = MediaQuery.of(context).size.height / (isTablet ? 2.3 : 3);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(child: title),
              ),
              const Divider(thickness: 1.5),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                height: height - (isTablet ? 50 : 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: content,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: actionButtons,
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              )
            ],
          ),
        );
      },
    );
  }
  return showDialog<String>(
    context: context,
    builder: (context) {
      var width = MediaQuery.of(context).size.width;
      return AlertDialog(
        title: title,
        content: Container(
          width: width - 50,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: content,
        ),
        actions: actionButtons,
      );
    },
  );
}

void launchWidgit(BuildContext context, String title, Widget content) {
  launchModal(
    context,
    H2(title),
    content,
    const [ModalButton('Done!')],
    true,
  );
}

class ModalListElement {
  final String id;
  final String name;

  const ModalListElement({
    required this.id,
    required this.name,
  });
}

class ModalButton extends StatelessWidget {
  final void Function()? onPressed;
  final String Function()? sendWithPop;
  final String text;

  const ModalButton(
    this.text, {
    this.onPressed,
    this.sendWithPop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
        onPressed: () {
          Navigator.pop(context, sendWithPop?.call());
          onPressed?.call();
        },
        child: T3(text, color: Colors.black),
      ),
    );
  }
}

class Modal {
  final BuildContext context;

  Modal(this.context);

  Future<String?> getName(String title, [String? defaultName]) {
    final controller = TextEditingController(text: defaultName);
    return launchModal(
      context,
      H2(title),
      TextField(
        controller: controller,
        style: TextStyle(fontSize: isTablet ? fontSizeOf.t2 : fontSizeOf.t1),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Name",
        ),
      ),
      [
        ModalButton(
          "Done",
          sendWithPop: () => controller.text,
        ),
        const ModalButton("Back"),
      ],
      true,
      true,
    );
  }

  Future<String?> selectOne<T extends ModalListElement>({
    required String title,
    required T? currentlySelected,
    required Iterable<T> modalListElement,
    required void Function(T) onSelect,
  }) {
    return launchModal(
      context,
      H2("Select one of the below $title"),
      Center(
        child: DropdownButton<T>(
          borderRadius: BorderRadius.circular(10),
          value: currentlySelected,
          icon: const IconH1(
            Icons.location_on_outlined,
            color: Colors.deepPurple,
          ),
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple, fontSize: fontSizeOf.h1),
          itemHeight: fontSizeOf.x1,
          onChanged: (e) {
            if (e == null) return;
            Navigator.pop(context, e.id);
            onSelect(e);
          },
          items: modalListElement
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Center(child: H1(e.name)),
                ),
              )
              .toList(),
        ),
      ),
      const [ModalButton("Back")],
      true,
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
      [const ModalButton("No"), ModalButton("Yes", sendWithPop: () => "Yes")],
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
      [
        if (onOk != null) const ModalButton("Back"),
        ModalButton(okText ?? "OK!", onPressed: onOk),
      ],
    );
  }
}

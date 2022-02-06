import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_changes.dart';
import 'package:vdp/utils/typography.dart';

class ShowStockChanges<T extends Changes> extends StatelessWidget {
  const ShowStockChanges({
    Key? key,
    required this.changes,
    required this.onChangesSelect,
    required this.deleteChanges,
  }) : super(key: key);

  final List<T> changes;
  final void Function(T changes) onChangesSelect;
  final void Function(T changes) deleteChanges;

  Widget table(List<String> column1, List<String> column2) {
    final children = <Widget>[];
    for (var i = 0; i < min(column1.length, column2.length); i++) {
      children.add(Flexible(
        flex: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            P2(column1[i]),
            P2(column2[i]),
          ],
        ),
      ));
    }
    children.add(const Spacer());
    return Row(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Changes")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: changes.length * 2,
            itemBuilder: (context, i) {
              if (i.isOdd) return const Divider(thickness: 1);
              i ~/= 2;
              var change = changes.elementAt(i);
              final ListTile listTile;
              if (change is TransferStockChanges) {
                listTile = ListTile(
                  onTap: () {
                    onChangesSelect(change);
                    Navigator.pop(context);
                  },
                  subtitle: table([
                    "Current Qun",
                    "Send Qun",
                    "Final Qun"
                  ], [
                    change.currentQuntity.text,
                    change.sendQuntity.text,
                    change.afterSendQuntity.text
                  ]),
                  title: T1(change.item.name),
                );
              } else if (change is StockSettingChanges) {
                listTile = ListTile(
                  onTap: () {
                    onChangesSelect(change);
                    Navigator.pop(context);
                  },
                  trailing: change.isSetStock
                      ? const IconH1(Icons.error_rounded, color: Colors.red)
                      : const IconH1(Icons.addchart_rounded,
                          color: Colors.green),
                  subtitle: table(
                      change.isSetStock
                          ? ["Current Qun", "Changed Qun", "Set Qun"]
                          : ["Current Qun", "Added Qun", "Final Qun"],
                      [
                        change.currentQuntity.text,
                        change.addedQuntity.text,
                        change.setQuntity.text
                      ]),
                  title: T1(change.item.name),
                );
              } else {
                listTile = ListTile(
                  onTap: () {
                    onChangesSelect(change);
                    Navigator.pop(context);
                  },
                  title: T1(change.item.name),
                );
              }
              return Dismissible(
                key: Key(change.itemId),
                onDismissed: (direction) {
                  deleteChanges(change);
                  if (changes.isEmpty) Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Changes with id ${change.itemId} was removed',
                      ),
                    ),
                  );
                },
                child: listTile,
                background: Container(color: Colors.red),
              );
            }),
      ),
    );
  }
}

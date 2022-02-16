import 'package:flutter/material.dart';
import 'package:vdp/documents/utils/stock_changes.dart';
import 'package:vdp/utils/build_list_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return BuildListPage<T>(
      topic: "Select Order",
      wrapScaffold: true,
      buildChild: (context, change) {
        return ListTilePage(
          onClick: () {
            onChangesSelect(change);
            Navigator.pop(context);
          },
          title: change.item.name,
          preview: change is TransferStockChanges
              ? Preview.table([
                  "Current Qun",
                  "Send Qun",
                  "Final Qun"
                ], [
                  change.currentQuntity.text,
                  change.sendQuntity.text,
                  change.afterSendQuntity.text
                ])
              : change is StockSettingChanges
                  ? Preview.table(
                      change.isSetStock
                          ? ["Current Qun", "Changed Qun", "Set Qun"]
                          : ["Current Qun", "Added Qun", "Final Qun"],
                      [
                          change.currentQuntity.text,
                          change.addedQuntity.text,
                          change.setQuntity.text
                        ])
                  : const Preview.empty(),
          trailingWidgit: change is StockSettingChanges
              ? TrailingWidgit.icon(
                  change.isSetStock
                      ? const IconH1(
                          Icons.error_rounded,
                          color: Colors.red,
                        )
                      : const IconH1(
                          Icons.addchart_rounded,
                          color: Colors.green,
                        ),
                )
              : null,
        );
      },
      onDismissed: (change) {
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
      noDataText: "No Order here",
      list: changes,
    );
  }
}

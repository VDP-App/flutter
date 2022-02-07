import 'package:flutter/material.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/modal.dart';
import 'package:vdp/utils/random.dart';
import 'package:vdp/utils/typography.dart';

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    Key? key,
    required this.action,
    required this.color,
    required this.icon,
  }) : super(key: key);

  final Future<void> Function() action;
  final Icon icon;
  final Color color;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  var loading = false;
  var disable = false;
  @override
  Widget build(BuildContext context) {
    final modal = Modal(context);
    return FloatingActionButton(
      heroTag: widget.key,
      onPressed: () async {
        if (loading || disable) return;
        if (!await modal.shouldProceed()) return;
        setState(() => loading = true);
        await widget.action();
        setState(() {
          loading = false;
          disable = true;
        });
      },
      backgroundColor: widget.color,
      child: loading ? loadingIconWigit : widget.icon,
    );
  }
}

class TrailingWidgit {
  final Widget widget;

  TrailingWidgit.actionButton({
    required Future<void> Function() action,
    required Color color,
    required Icon icon,
  }) : widget = _ActionButton(action: action, color: color, icon: icon);
  TrailingWidgit.icon(TypoIcon icon) : widget = icon;
  TrailingWidgit.text(TypoText text) : widget = text;
}

class LeadingWidgit {
  final Widget widget;

  LeadingWidgit.badge({required Color color})
      : widget = Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: color,
          ),
          width: 10,
        );

  LeadingWidgit.text(TypoText text) : widget = text;
}

class _PreviewTable extends StatelessWidget {
  const _PreviewTable({
    Key? key,
    required this.column1,
    required this.column2,
    this.rowToColumn = true,
  }) : super(key: key);
  final List<String> column1;
  final List<String> column2;
  final bool rowToColumn;
  @override
  Widget build(BuildContext context) {
    if (!rowToColumn) {
      return Column(children: [
        const SizedBox(height: 5),
        Row(
          children: column1.map((e) => P2(e, color: Colors.blue)).toList(),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        Row(
          children: column2.map((e) => P2(e)).toList(),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        )
      ]);
    }
    final children = <Widget>[];
    for (var i = 0; i < column1.length; i++) {
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
}

class Preview {
  final Widget widget;

  Preview.text(TypoText text) : widget = text;
  Preview.table(List<String> column1, List<String> column2)
      : widget = _PreviewTable(
          column1: column1,
          column2: column2,
        );
  Preview.info(List<String> column1, List<String> column2)
      : widget = _PreviewTable(
          column1: column1,
          column2: column2,
          rowToColumn: false,
        );
  const Preview.empty() : widget = const SizedBox.shrink();
}

class ListTilePage extends ListTile {
  ListTilePage({
    Key? key,
    required String title,
    required Preview preview,
    void Function()? onClick,
    LeadingWidgit? leadingWidgit,
    TrailingWidgit? trailingWidgit,
    Color? color,
  }) : super(
          key: key,
          tileColor: color,
          onTap: onClick,
          leading: leadingWidgit?.widget,
          title: T1(title),
          trailing: trailingWidgit?.widget,
          subtitle: preview.widget,
        );

  const ListTilePage.empty({Key? key}) : super(key: key);
}

class BuildListPage<T> extends StatelessWidget {
  const BuildListPage({
    Key? key,
    required this.wrapScaffold,
    required this.buildChild,
    required this.noDataText,
    required this.list,
    this.startWith = const [],
    this.endWith = const [],
    this.floatingActionButton,
    this.appBarTitle,
    this.onDismissed,
  }) : super(key: key);

  final Iterable<T> list;
  final bool wrapScaffold;
  final Iterable<Widget> startWith;
  final ListTilePage Function(BuildContext context, T element) buildChild;
  final Iterable<Widget> endWith;
  final Widget? floatingActionButton;
  final String? noDataText;
  final String? appBarTitle;
  final void Function(T element)? onDismissed;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty && noDataText != null) return NoData(text: noDataText!);
    final l = startWith.length;
    final t = endWith.length;
    final itemCount = list.length;
    Widget widget = ListView.separated(
      itemCount: l + itemCount + t,
      itemBuilder: onDismissed == null
          ? (context, i) {
              if (i < l) return startWith.elementAt(i);
              i -= l;
              if (i < itemCount) return buildChild(context, list.elementAt(i));
              i -= itemCount;
              return endWith.elementAt(i);
            }
          : (context, i) {
              if (i < l) return startWith.elementAt(i);
              i -= l;
              var e = list.elementAt(i);
              if (i < itemCount) {
                return Dismissible(
                  key: Key(randomString),
                  onDismissed: (direction) => onDismissed!.call(e),
                  background: Container(color: Colors.red),
                  child: buildChild(context, e),
                );
              }
              i -= itemCount;
              return endWith.elementAt(i);
            },
      separatorBuilder: (context, i) {
        if (l > 0) {
          if (i < l - 1) return const SizedBox(height: 8);
          if (i == l - 1) return const Divider(thickness: 3);
          i -= l;
        }
        if (i < itemCount - 1) return const Divider(thickness: 1.5);
        if (t > 0 && i == itemCount - 1) return const Divider(thickness: 3);
        return const SizedBox(height: 8);
      },
    );
    if (wrapScaffold) {
      widget = Scaffold(
        appBar: appBarTitle != null ? AppBar(title: Text(appBarTitle!)) : null,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget,
        ),
        floatingActionButton: floatingActionButton,
      );
    } else if (floatingActionButton != null) {
      widget = Scaffold(
        body: widget,
        floatingActionButton: floatingActionButton,
      );
    }
    return widget;
  }
}

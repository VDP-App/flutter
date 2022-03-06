import 'package:flutter/material.dart';
import 'package:vdp/documents/logs.dart';
import 'package:vdp/main.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/logs.dart';
import 'package:vdp/utils/build_list_page.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';
import 'package:vdp/widgets/items/show_logs.dart';
import 'package:provider/provider.dart';

class DisplayLogs extends StatelessWidget {
  const DisplayLogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<Products, Logs>(
      create: (context) => Logs(context),
      update: (context, products, previous) {
        previous ??= Logs(context);
        final pageNum = products.doc?.logPage;
        if (pageNum != null) previous.update(pageNum);
        return previous;
      },
      child: const _Logs(),
    );
  }
}

class _OnEnd extends StatelessWidget {
  const _OnEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logs = Provider.of<Logs>(context, listen: false);
    if (!logs.isLoading) logs.loadNextPage();
    return const Center(child: loadingWigitLinier, heightFactor: 10);
  }
}

final alreadySeen = (sharedPreferences.getStringList("logs") ?? []).toSet();
void addSeen(Log log) {
  alreadySeen.add(log.createdAt);
  sharedPreferences.setStringList("logs", alreadySeen.toList());
}

void unSeen(Log log) {
  alreadySeen.remove(log.createdAt);
  sharedPreferences.setStringList("logs", alreadySeen.toList());
}

bool haveSeen(Log log) {
  return alreadySeen.contains(log.createdAt);
}

class _Logs extends StatefulWidget {
  const _Logs({Key? key}) : super(key: key);

  @override
  State<_Logs> createState() => _LogsState();
}

class _LogsState extends State<_Logs> {
  @override
  Widget build(BuildContext context) {
    var logs = Provider.of<Logs>(context);
    return BuildListPage<Log>(
      list: logs.list,
      wrapScaffold: true,
      noDataText: null,
      buildChild: (context, log) {
        final isImp = log.isImportant;
        return ListTilePage(
          color: haveSeen(log) ? null : Colors.blueAccent[100],
          onClick: () => openLog(context, log).then((value) {
            if (value) setState(() {});
          }),
          leadingWidgit: LeadingWidgit.badge(
            color: isImp ? Colors.red : Colors.green,
          ),
          title: log.product.name,
          preview: Preview.text(
            P2(log.preview, color: isImp ? Colors.red : Colors.green),
          ),
          trailingWidgit: TrailingWidgit.icon(
            log.isCreateItemLog
                ? const IconT3(Icons.add, color: Colors.green)
                : log.isRemoveItemLog
                    ? const IconT3(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      )
                    : const IconT3(
                        Icons.update_rounded,
                        color: Colors.blue,
                      ),
          ),
        );
      },
      endWith: logs.isDone ? [] : const [_OnEnd()],
    );
  }
}

Future<bool> openLog(BuildContext context, Log log) {
  return Navigator.push<String>(context, MaterialPageRoute(builder: (context) {
    return ShowLogs(log: log);
  })).then((value) => value is String);
}

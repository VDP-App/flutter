import 'package:flutter/material.dart';
import 'package:vdp/documents/logs.dart';
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

class _Logs extends StatelessWidget {
  const _Logs({Key? key}) : super(key: key);

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
          onClick: () => openLog(context, log),
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

openLog(BuildContext context, Log log) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ShowLogs(log: log);
  }));
}

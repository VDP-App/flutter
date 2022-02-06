import 'package:flutter/material.dart';
import 'package:vdp/documents/logs.dart';
import 'package:vdp/providers/doc/products.dart';
import 'package:vdp/providers/doc/logs.dart';
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

class _Logs extends StatelessWidget {
  const _Logs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logs = Provider.of<Logs>(context);
    if (logs.isDone && logs.length == 0) {
      return const NoData(text: "No Logs Found");
    }
    return ListView.builder(
        itemCount: logs.length * 2 + (logs.isDone ? 0 : 1),
        itemBuilder: (context, i) {
          if (logs.isNotDone && i == logs.length * 2) {
            if (!logs.isLoading) logs.loadNextPage();
            return const Center(child: loadingWigitLinier, heightFactor: 10);
          }
          if (i.isOdd) return const Divider(thickness: 1.5);
          final log = logs[i ~/ 2];
          final isImp = log.isImportant;
          return ListTile(
            onTap: () => openLog(context, log),
            leading: Container(
              decoration: isImp == null
                  ? null
                  : BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: isImp ? Colors.red : Colors.green,
                    ),
              width: 10,
            ),
            minLeadingWidth: 20,
            title: T1(log.product.name),
            trailing: log.isCreateItemLog
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
            subtitle: P2(log.preview),
          );
        });
  }
}

openLog(BuildContext context, Log log) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ShowLogs(log: log);
  }));
}

import 'package:flutter/material.dart';
import 'package:vdp/documents/logs.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:vdp/utils/modal.dart';

const _collectionPath = "logs";

LogDoc _computeFn(Map<String, dynamic> data) {
  return LogDoc.fromJson(data);
}

class Logs extends Modal with ChangeNotifier {
  final List<Log> _logs = [];
  int _logPage = 0;
  bool _loading = false;
  int _reset = 1;

  static const _maxLogsInDoc = 51;

  Logs(BuildContext context) : super(context);

  void update(int logPage) {
    if (logPage <= 0) return;
    _reset++;
    _logPage = logPage;
    _loading = false;
    _logs.clear();
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (isDone || _loading) return;
    final pageNum = _logPage--;
    final reset = _reset;
    LogDoc? doc;
    if (doc == null) {
      _loading = true;
      doc = await getDoc(
        docPath: "$_collectionPath/$pageNum",
        converter: _computeFn,
        getDocFrom: GetDocFrom.cacheIfNotThenServer,
      );
      if (doc == null || doc.logs.length < _maxLogsInDoc) {
        doc = await getDoc(
          docPath: "$_collectionPath/$pageNum",
          converter: _computeFn,
          getDocFrom: GetDocFrom.serverIfNotThenCache,
        );
      }
      if (reset != _reset) return;
      _loading = false;
      if (doc == null) {
        _logPage = 0;
      } else {
        _logs.addAll(doc.logs);
      }
    } else {
      _logs.addAll(doc.logs);
    }
    notifyListeners();
  }

  Log operator [](int i) => _logs[i];
  bool get isLoading => _loading;
  bool get isDone => _logPage <= 0;
  bool get isNotDone => _logPage > 0;
  int get length => _logs.length;
  List<Log> get list => _logs;
}

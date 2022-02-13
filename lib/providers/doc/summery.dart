import 'package:flutter/material.dart';
import 'package:vdp/documents/summery.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:vdp/utils/modal.dart';

String _path(String stockID, String date) => "stocks/$stockID/summery/$date";

SummeryDoc _computeFn(Map<String, dynamic> data) {
  return SummeryDoc.fromJson(data);
}

class Summery extends Modal with ChangeNotifier {
  String? _stockID;
  String? _date;
  SummeryDoc? _doc;
  bool? _isEmpty;

  static final _docs = <String, SummeryDoc?>{};

  Summery(BuildContext context) : super(context);

  void update(String stockID) {
    if (stockID == _stockID) return;
    _stockID = stockID;
    _getDoc();
  }

  void changeDate(String date) {
    if (_date == date) return;
    _date = date;
    _getDoc();
  }

  void _getDoc() async {
    _doc = null;
    _isEmpty = null;
    notifyListeners();
    final stockID = _stockID, date = _date;
    if (stockID == null || date == null) return;
    final path = _path(stockID, date);
    SummeryDoc? doc;
    if (_docs.containsKey(path)) {
      doc = _docs[path];
    } else {
      doc = await getDoc(
        docPath: path,
        converter: _computeFn,
        getDocFrom: GetDocFrom.cacheIfNotThenServer,
      );
      _docs[path] = doc;
    }
    if (stockID != _stockID || date != _date) return;
    _doc = doc;
    _isEmpty = doc == null;
  }

  String? get date => _date;
  SummeryDoc? get doc => _doc;
  bool? get isEmpty => _isEmpty;

  @override
  void dispose() {
    _docs.clear();
    super.dispose();
  }
}

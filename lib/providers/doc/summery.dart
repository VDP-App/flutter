import 'package:flutter/material.dart';
import 'package:vdp/documents/summery.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:intl/intl.dart';

String _path(String stockID, String date) => "stocks/$stockID/summery/$date";

SummeryDoc _computeFn(Map<String, dynamic> data) {
  return SummeryDoc.fromJson(data);
}

final format = DateFormat("yyyy-MM-dd").format;

String? formateDateTime(DateTime? dateTime) =>
    dateTime == null ? null : format(dateTime);

class Summery with ChangeNotifier {
  String? _stockID;
  DateTime? _date;
  SummeryDoc? _doc;
  bool? _isEmpty = false;

  static final _docs = <String, SummeryDoc?>{};

  void update(String stockID) {
    if (stockID == _stockID) return;
    _stockID = stockID;
    _getDoc();
  }

  void changeDate(DateTime date) {
    if (dateInString == formateDateTime(date)) return;
    _date = date;
    _getDoc();
  }

  void _getDoc() async {
    _doc = null;
    _isEmpty = null;
    notifyListeners();
    final stockID = _stockID, date = dateInString;
    if (stockID == null || date == null) {
      _isEmpty = false;
      return;
    }
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
    if (stockID != _stockID || date != dateInString) return;
    _doc = doc;
    _isEmpty = doc == null;
    notifyListeners();
  }

  DateTime? get date => _date;
  String? get dateInString => formateDateTime(_date);
  SummeryDoc? get doc => _doc;
  bool? get isEmpty => _isEmpty;

  @override
  void dispose() {
    _docs.clear();
    super.dispose();
  }
}

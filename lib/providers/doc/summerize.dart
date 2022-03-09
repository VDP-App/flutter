import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vdp/documents/summerize.dart';
import 'package:vdp/utils/firestore_document.dart';
import 'package:intl/intl.dart';

String _path(String stockID, String date) => "stocks/$stockID/summery/$date";

SummerizeDoc _computeFn(List<Map<String, dynamic>?> data) {
  return SummerizeDoc.fromJson(data);
}

final format = DateFormat("yyyy-MM-dd").format;

String? formateDateTimeRange(DateTimeRange? dateTimeRange) =>
    dateTimeRange == null
        ? null
        : (format(dateTimeRange.start) + " to " + format(dateTimeRange.end));

String formateDateTimeShort(DateTime dateTime) =>
    format(dateTime).substring(5).replaceFirst("-", "/");

class Summerize with ChangeNotifier {
  String? _stockID;
  DateTimeRange? _dateTimeRange;
  SummerizeDoc? _doc;

  void update(String stockID) {
    if (stockID == _stockID) return;
    _stockID = stockID;
    _getDoc();
  }

  void changeDate(DateTimeRange dateTimeRange) {
    if (dateTimeRangeInString == formateDateTimeRange(dateTimeRange)) return;
    _dateTimeRange = dateTimeRange;
    _getDoc();
  }

  void _getDoc() async {
    _doc = null;
    notifyListeners();
    final stockID = _stockID,
        dates = datesInString,
        dateStr = dateTimeRangeInString;
    if (stockID == null || dates == null) return;
    final docs = await Future.wait(dates.map((date) {
      final path = _path(stockID, date);
      return getDoc(
        docPath: path,
        converter: (x) {
          x["date"] = date;
          return x;
        },
        getDocFrom: GetDocFrom.cacheIfNotThenServer,
      );
    }));
    if (stockID != _stockID || dateStr != dateTimeRangeInString) return;
    final a = await compute(_computeFn, docs);
    if (stockID != _stockID || dateStr != dateTimeRangeInString) return;
    _doc = a;
    notifyListeners();
  }

  List<String>? get datesInString {
    final d = _dateTimeRange;
    if (d == null) return null;
    final r = d.end.difference(d.start).inDays;
    final days = <String>[];
    for (int i = 0; i <= r; i++) {
      days.add(format(d.start.add(Duration(days: i))));
    }
    return days;
  }

  DateTimeRange? get dateTimeRange => _dateTimeRange;
  String? get dateTimeRangeInString => formateDateTimeRange(_dateTimeRange);
  String? get dateTimeRangeInShort {
    final d = _dateTimeRange;
    if (d == null) return null;
    return formateDateTimeShort(d.start) + " - " + formateDateTimeShort(d.end);
  }

  SummerizeDoc? get doc => _doc;
}

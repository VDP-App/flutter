import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

enum GetDocFrom {
  cacheIfNotThenServer,
  serverIfNotThenCache,
}

Future<T?> getDoc<T>({
  required String docPath,
  GetDocFrom getDocFrom = GetDocFrom.serverIfNotThenCache,
  required FutureOr<T?> Function(Map<String, dynamic> data) converter,
}) async {
  Future<Map<String, dynamic>?> _getDoc(Source source) {
    return FirebaseFirestore.instance
        .doc(docPath)
        .get(GetOptions(source: source))
        .then((value) => value.data());
  }

  Map<String, dynamic>? data;

  switch (getDocFrom) {
    case GetDocFrom.cacheIfNotThenServer:
      try {
        data = await _getDoc(Source.cache);
      } catch (_) {
        data = await _getDoc(Source.server);
      }
      break;
    case GetDocFrom.serverIfNotThenCache:
      try {
        data = await _getDoc(Source.server);
      } catch (_) {
        data = await _getDoc(Source.cache);
      }
      break;
  }

  if (data != null) return await converter(data);
  return null;
}

class FirestoreDoc<T> {
  final _controller = StreamController<T>();
  final FutureOr<T?> Function(Map<String, dynamic> data) converter;
  final String documentPath;
  StreamSubscription? _streamSubscription;

  FirestoreDoc({
    required this.documentPath,
    required this.converter,
  }) {
    _controller.onListen = () => _streamSubscription = _setSubscription();
    _controller.onPause = () => _streamSubscription?.pause();
    _controller.onResume = () => _streamSubscription?.pause();
    _controller.onCancel = () {
      _streamSubscription?.cancel();
      _streamSubscription = null;
    };
  }

  StreamSubscription _setSubscription() {
    return FirebaseFirestore.instance.doc(documentPath).snapshots().listen(
      (events) {
        final value = events.data();
        if (value != null) {
          _parseData(value);
        }
      },
      onError: (error) {
        _controller.sink.addError(error, StackTrace.current);
      },
      cancelOnError: false,
    );
  }

  void _parseData(Map<String, dynamic> data) async {
    final parsedData = await converter(data);
    if (parsedData is T) {
      _controller.sink.add(parsedData);
    }
  }

  Stream<T> get stream => _controller.stream;
}

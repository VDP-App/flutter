import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

enum GetDocFrom {
  cacheIfNotThenServer,
  serverIfNotThenCache,
}

Future<Map<String, dynamic>?> _getDoc(String docPath, Source source) {
  return FirebaseFirestore.instance
      .doc(docPath)
      .get(GetOptions(source: source))
      .then((value) => value.data());
}

Future<T?> getDoc<T>({
  required String docPath,
  GetDocFrom getDocFrom = GetDocFrom.serverIfNotThenCache,
  required FutureOr<T?> Function(Map<String, dynamic> data) converter,
}) async {
  Map<String, dynamic>? data;

  switch (getDocFrom) {
    case GetDocFrom.cacheIfNotThenServer:
      try {
        data = await _getDoc(docPath, Source.cache);
      } catch (_) {
        data = await _getDoc(docPath, Source.server);
      }
      break;
    case GetDocFrom.serverIfNotThenCache:
      try {
        data = await _getDoc(docPath, Source.server);
      } catch (_) {
        data = await _getDoc(docPath, Source.cache);
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
    print('FirestoreDoc(documentPath: "$documentPath")');
    _controller.onListen = () => _streamSubscription = _setSubscription();
    _controller.onPause = () => _streamSubscription?.pause();
    _controller.onResume = () => _streamSubscription?.pause();
    _controller.onCancel = () {
      _streamSubscription?.cancel();
      _streamSubscription = null;
    };
  }

  StreamSubscription _setSubscription() {
    print('_setSubscription(documentPath: "$documentPath")');
    print('apiKey = ' + FirebaseFirestore.instance.app.options.apiKey);
    return FirebaseFirestore.instance.doc(documentPath).snapshots().listen(
      (events) {
        print(
            'listened(documentPath: "$documentPath", isFromCache: ${events.metadata.isFromCache}, event: ${events.data()})');
        final value = events.data();
        if (value != null) {
          _parseData(value);
        }
      },
      onError: (error) {
        print('onError(documentPath: "$documentPath", error: $error)');
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

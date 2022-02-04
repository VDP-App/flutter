import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

String get randomString {
  final r = Random();
  String randomChr() => _chars[r.nextInt(_chars.length)];
  return List.generate(10, (_) => randomChr()).join();
}

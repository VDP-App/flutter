import 'dart:convert';

Map<String, dynamic> asMap(dynamic val) {
  if (val is Map<String, dynamic>) return val;
  return const {};
}

List asList(dynamic val) {
  if (val is List) return val;
  return const [];
}

String asString(dynamic val, [String defaultVal = ""]) {
  if (val is String) return val;
  return defaultVal;
}

int asInt(dynamic val) {
  if (val is int) return val;
  return 0;
}

String? asNullOrString(dynamic val) {
  if (val is String) return val;
  return null;
}

bool asBool(dynamic val) => val is bool ? val : false;

dynamic parseJson(dynamic e) => e is String ? jsonDecode(e) : e;

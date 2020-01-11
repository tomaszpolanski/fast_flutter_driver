// ignore_for_file: implementation_imports

import 'package:meta/meta.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/declarer.dart';

@isTest
void testUI(
  String description,
  dynamic Function(String description) body, {
  String testOn,
  Timeout timeout = const Timeout(Duration(seconds: 30)),
  bool skip,
  dynamic tags,
  Map<String, dynamic> onPlatform,
  int retry,
}) {
  Declarer.current.test(
    description,
    () => body(description.replaceAll('"', '')),
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    onPlatform: onPlatform,
    tags: tags,
    retry: retry,
    solo: false,
  );
}

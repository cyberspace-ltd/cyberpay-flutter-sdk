import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyberpayflutter/cyberpayflutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('cyberpayflutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Cyberpayflutter.platformVersion, '42');
  });
}

// integration_test の screenshot 出力ハンドラ。
//
// integration_test/screenshots_test.dart で binding.takeScreenshot(name) されると
// onScreenshot に bytes が流れてくるので PNG として保存する。

import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (
      String name,
      List<int> bytes, [
      Map<String, Object?>? args,
    ]) async {
      final file = File('screenshots/$name.png');
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      stdout.writeln('saved: ${file.path} (${bytes.length} bytes)');
      return true;
    },
  );
}

// Play Store スクリーンショット撮影用 integration test。
//
// 実行: flutter drive \
//          --driver=test_driver/integration_test.dart \
//          --target=integration_test/screenshots_test.dart \
//          --profile
//
// 出力先: <project>/screenshots/<name>.png
// 詳細: scripts/capture-screenshots.sh 参照

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cocktail_recipe_manager/main.dart' as app;

Future<void> _shot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name,
) async {
  if (Platform.isAndroid) {
    // Android では Flutter surface を画像化しないと真っ黒になる
    await binding.convertFlutterSurfaceToImage();
  }
  await tester.pumpAndSettle(const Duration(milliseconds: 250));
  await binding.takeScreenshot(name);
}

Future<void> _back(WidgetTester tester) async {
  // AppBar の戻るボタン (BackButton) は tooltip "Back"
  final back = find.byTooltip('Back');
  if (back.evaluate().isNotEmpty) {
    await tester.tap(back.first);
  } else {
    // フォールバック: arrow_back アイコン
    await tester.tap(find.byIcon(Icons.arrow_back).first);
  }
  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Play Store screenshots', (tester) async {
    app.main();
    // 起動 + DB 初期化 + プリセット seeding を待つ
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 1. レシピ一覧
    await _shot(binding, tester, '01_recipe_list');

    // 2. レシピ詳細（先頭の ListTile をタップ）
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    await _shot(binding, tester, '02_recipe_detail');

    // 一覧に戻る
    await _back(tester);

    // 3. レシピ追加フォーム
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    await _shot(binding, tester, '03_recipe_form');

    // 一覧に戻る
    await _back(tester);

    // 4. カテゴリ画面
    await tester.tap(find.byIcon(Icons.category_outlined).first);
    await tester.pumpAndSettle();
    await _shot(binding, tester, '04_category');

    // 一覧に戻る
    await _back(tester);

    // 5. 設定画面
    await tester.tap(find.byIcon(Icons.settings_outlined).first);
    await tester.pumpAndSettle();
    await _shot(binding, tester, '05_settings');
  });
}

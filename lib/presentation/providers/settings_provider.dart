import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/strings/app_strings.dart';

class DefaultUnitNotifier extends StateNotifier<String> {
  DefaultUnitNotifier() : super(AppStrings.unitMl) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(PrefsKey.defaultUnit) ?? AppStrings.unitMl;
  }

  Future<void> set(String unit) async {
    state = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefsKey.defaultUnit, unit);
  }
}

final defaultUnitProvider = StateNotifierProvider<DefaultUnitNotifier, String>(
  (ref) => DefaultUnitNotifier(),
);

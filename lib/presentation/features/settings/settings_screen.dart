import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/strings/app_strings.dart';

final _defaultUnitProvider =
    StateNotifierProvider<_UnitNotifier, String>((ref) => _UnitNotifier());

class _UnitNotifier extends StateNotifier<String> {
  _UnitNotifier() : super(AppStrings.unitMl) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('default_unit') ?? AppStrings.unitMl;
  }

  Future<void> set(String unit) async {
    state = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('default_unit', unit);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(_defaultUnitProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navSettings)),
      body: ListView(
        children: [
          ListTile(
            title: const Text(AppStrings.defaultUnit),
            trailing: DropdownButton<String>(
              value: unit,
              items: [AppStrings.unitMl, AppStrings.unitOz]
                  .map((u) =>
                      DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (v) =>
                  ref.read(_defaultUnitProvider.notifier).set(v!),
            ),
          ),
        ],
      ),
    );
  }
}

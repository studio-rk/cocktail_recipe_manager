import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/strings/app_strings.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(defaultUnitProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navSettings)),
      body: ListView(
        children: [
          ListTile(
            title: const Text(AppStrings.defaultUnit),
            trailing: DropdownButton<String>(
              value: unit,
              items: [
                AppStrings.unitMl,
                AppStrings.unitOz,
              ].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => ref.read(defaultUnitProvider.notifier).set(v!),
            ),
          ),
        ],
      ),
    );
  }
}

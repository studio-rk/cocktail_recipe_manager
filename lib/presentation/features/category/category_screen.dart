import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/strings/app_strings.dart';
import '../../../domain/entities/category_entity.dart';
import '../../providers/category_provider.dart';
import '../../providers/recipe_provider.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navCategories)),
      body: categoriesAsync.when(
        data: (cats) => cats.isEmpty
            ? const Center(child: Text('カテゴリがありません'))
            : ListView.builder(
                itemCount: cats.length,
                itemBuilder: (_, i) {
                  final c = cats[i];
                  return ListTile(
                    leading: Text(c.icon, style: const TextStyle(fontSize: 24)),
                    title: Text(c.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(ref, c),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _delete(WidgetRef ref, CategoryEntity category) async {
    await ref.read(recipeRepositoryProvider).deleteCategory(category.id);
    ref.invalidate(categoriesProvider);
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final iconCtrl = TextEditingController(text: '🍹');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.addCategory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: iconCtrl,
              decoration: const InputDecoration(labelText: '絵文字'),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.categoryName,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              await ref
                  .read(recipeRepositoryProvider)
                  .insertCategory(
                    CategoryEntity(
                      id: 0,
                      name: nameCtrl.text.trim(),
                      icon: iconCtrl.text.trim(),
                    ),
                  );
              ref.invalidate(categoriesProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }
}

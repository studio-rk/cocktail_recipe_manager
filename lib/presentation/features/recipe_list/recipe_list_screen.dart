import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/category_provider.dart';

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(filteredRecipesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(categoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            onPressed: () => context.push(AppRoute.category.path),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoute.settings.path),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              hintText: AppStrings.searchHint,
              onChanged: (q) =>
                  ref.read(searchQueryProvider.notifier).state = q,
            ),
          ),
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _CategoryChip(
                    label: AppStrings.allCategories,
                    selected: selectedCategory == null,
                    onTap: () =>
                        ref.read(categoryFilterProvider.notifier).state = null,
                  ),
                  ...categories.map(
                    (c) => _CategoryChip(
                      label: '${c.icon} ${c.name}',
                      selected: selectedCategory == c.id,
                      onTap: () =>
                          ref.read(categoryFilterProvider.notifier).state =
                              c.id,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 44),
            error: (_, __) => const SizedBox(height: 44),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: recipesAsync.when(
              data: (recipes) => recipes.isEmpty
                  ? const Center(child: Text(AppStrings.emptyRecipes))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: recipes.length,
                      itemBuilder: (_, i) {
                        final r = recipes[i];
                        return Card(
                          child: ListTile(
                            title: Text(r.name),
                            subtitle: Text('${r.ingredients.length}種類の材料'),
                            trailing: Icon(
                              r.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: r.isFavorite ? Colors.red : null,
                            ),
                            onTap: () => context.push('/recipe/${r.id}'),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoute.recipeAdd.path),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/recipe_entity.dart';
import '../../providers/recipe_provider.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});
  final int recipeId;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  double _multiplier = 1.0;

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));

    return recipeAsync.when(
      data: (recipe) {
        if (recipe == null) {
          return const Scaffold(body: Center(child: Text('Not found')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.name),
            actions: [
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(ref, recipe),
              ),
              if (!recipe.isPreset)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push('/recipe/${recipe.id}/edit'),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ScalingRow(
                multiplier: _multiplier,
                onChanged: (v) => setState(() => _multiplier = v),
              ),
              const SizedBox(height: 20),
              _SectionTitle(AppStrings.ingredients),
              ...recipe.ingredients.map((ing) {
                final scaled = ing.amount * _multiplier;
                final display = scaled == scaled.roundToDouble()
                    ? scaled.toInt().toString()
                    : scaled.toStringAsFixed(1);
                return ListTile(
                  dense: true,
                  title: Text(ing.name),
                  trailing: Text(
                    '$display ${ing.unit}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }),
              const SizedBox(height: 20),
              _SectionTitle(AppStrings.steps),
              ...recipe.steps.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e.value)),
                    ],
                  ),
                ),
              ),
              if (recipe.memo.isNotEmpty) ...[
                const SizedBox(height: 20),
                _SectionTitle(AppStrings.memo),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(recipe.memo),
                ),
              ],
              const SizedBox(height: 32),
              if (!recipe.isPreset)
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    AppStrings.deleteRecipe,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onPressed: () => _confirmDelete(context, ref, recipe),
                ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
    );
  }

  void _toggleFavorite(WidgetRef ref, RecipeEntity recipe) async {
    await ref
        .read(recipeRepositoryProvider)
        .toggleFavorite(recipe.id, !recipe.isFavorite);
    ref.invalidate(recipeDetailProvider(recipe.id));
    ref.invalidate(filteredRecipesProvider);
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RecipeEntity recipe,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.deleteRecipe),
        content: const Text(AppStrings.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(recipeRepositoryProvider).deleteRecipe(recipe.id);
              ref.invalidate(filteredRecipesProvider);
              if (context.mounted) {
                Navigator.pop(context);
                context.pop();
              }
            },
            child: Text(
              AppStrings.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScalingRow extends StatelessWidget {
  const _ScalingRow({required this.multiplier, required this.onChanged});
  final double multiplier;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: AppConstants.servingMultipliers.map((m) {
        final label = m == 0.5 ? '½' : '×${m.toInt()}';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(label),
            selected: multiplier == m,
            onSelected: (_) => onChanged(m),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

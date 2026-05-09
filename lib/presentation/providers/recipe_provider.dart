import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/entities/recipe_entity.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('appDatabaseProvider must be overridden in main()');
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RecipeRepositoryImpl(db);
});

final recipeDetailProvider = FutureProvider.family<RecipeEntity?, int>((
  ref,
  id,
) {
  return ref.watch(recipeRepositoryProvider).getRecipeById(id);
});

final categoryFilterProvider = StateProvider<int?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredRecipesProvider = FutureProvider<List<RecipeEntity>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final categoryId = ref.watch(categoryFilterProvider);

  final base = (categoryId != null)
      ? await repo.getRecipesByCategory(categoryId)
      : await repo.getRecipes();
  if (query.isEmpty) return base;
  final q = query.toLowerCase();
  return base.where((r) => r.name.toLowerCase().contains(q)).toList();
});

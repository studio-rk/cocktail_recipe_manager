import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/category_entity.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RecipeRepositoryImpl(db);
});

final recipesProvider = FutureProvider<List<RecipeEntity>>((ref) {
  return ref.watch(recipeRepositoryProvider).getRecipes();
});

final recipeDetailProvider =
    FutureProvider.family<RecipeEntity?, int>((ref, id) {
  return ref.watch(recipeRepositoryProvider).getRecipeById(id);
});

final categoryFilterProvider = StateProvider<int?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredRecipesProvider = FutureProvider<List<RecipeEntity>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final categoryId = ref.watch(categoryFilterProvider);

  if (query.isNotEmpty) return repo.searchRecipes(query);
  if (categoryId != null) return repo.getRecipesByCategory(categoryId);
  return repo.getRecipes();
});

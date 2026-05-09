import '../entities/recipe_entity.dart';
import '../entities/category_entity.dart';

abstract class RecipeRepository {
  Future<List<RecipeEntity>> getRecipes();
  Future<List<RecipeEntity>> searchRecipes(String query);
  Future<List<RecipeEntity>> getRecipesByCategory(int categoryId);
  Future<List<RecipeEntity>> getFavoriteRecipes();
  Future<RecipeEntity?> getRecipeById(int id);
  Future<int> insertRecipe(RecipeEntity recipe);
  Future<void> updateRecipe(RecipeEntity recipe);
  Future<void> deleteRecipe(int id);
  Future<void> toggleFavorite(int id, bool isFavorite);

  Future<List<CategoryEntity>> getCategories();
  Future<int> insertCategory(CategoryEntity category);
  Future<void> deleteCategory(int id);

  Future<void> seedPresets(
    List<RecipeEntity> recipes,
    List<CategoryEntity> categories,
  );
  Future<bool> hasSeededPresets();
}

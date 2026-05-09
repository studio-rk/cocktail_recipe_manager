import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/ingredient_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../database/app_database.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final AppDatabase _db;

  RecipeRepositoryImpl(this._db);

  @override
  Future<List<RecipeEntity>> getRecipes() async {
    final rows = await _db.select(_db.recipesTable).get();
    return Future.wait(rows.map(_rowToEntity));
  }

  @override
  Future<List<RecipeEntity>> searchRecipes(String query) async {
    final rows = await (_db.select(
      _db.recipesTable,
    )..where((t) => t.name.like('%$query%'))).get();
    return Future.wait(rows.map(_rowToEntity));
  }

  @override
  Future<List<RecipeEntity>> getRecipesByCategory(int categoryId) async {
    final rows = await (_db.select(
      _db.recipesTable,
    )..where((t) => t.categoryId.equals(categoryId))).get();
    return Future.wait(rows.map(_rowToEntity));
  }

  @override
  Future<List<RecipeEntity>> getFavoriteRecipes() async {
    final rows = await (_db.select(
      _db.recipesTable,
    )..where((t) => t.isFavorite.equals(true))).get();
    return Future.wait(rows.map(_rowToEntity));
  }

  @override
  Future<RecipeEntity?> getRecipeById(int id) async {
    final row = await (_db.select(
      _db.recipesTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _rowToEntity(row);
  }

  @override
  Future<int> insertRecipe(RecipeEntity recipe) {
    return _db.transaction(() async {
      final recipeId = await _db
          .into(_db.recipesTable)
          .insert(
            RecipesTableCompanion.insert(
              name: recipe.name,
              categoryId: Value(recipe.categoryId),
              steps: Value(jsonEncode(recipe.steps)),
              memo: Value(recipe.memo),
              isFavorite: Value(recipe.isFavorite),
              isPreset: Value(recipe.isPreset),
            ),
          );
      await _insertIngredients(recipeId, recipe.ingredients);
      return recipeId;
    });
  }

  @override
  Future<void> updateRecipe(RecipeEntity recipe) {
    return _db.transaction(() async {
      await (_db.update(
        _db.recipesTable,
      )..where((t) => t.id.equals(recipe.id))).write(
        RecipesTableCompanion(
          name: Value(recipe.name),
          categoryId: Value(recipe.categoryId),
          steps: Value(jsonEncode(recipe.steps)),
          memo: Value(recipe.memo),
          isFavorite: Value(recipe.isFavorite),
        ),
      );
      await (_db.delete(
        _db.ingredientsTable,
      )..where((t) => t.recipeId.equals(recipe.id))).go();
      await _insertIngredients(recipe.id, recipe.ingredients);
    });
  }

  @override
  Future<void> deleteRecipe(int id) async {
    await (_db.delete(_db.recipesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await (_db.update(_db.recipesTable)..where((t) => t.id.equals(id))).write(
      RecipesTableCompanion(isFavorite: Value(isFavorite)),
    );
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final rows = await _db.select(_db.categoriesTable).get();
    return rows
        .map((r) => CategoryEntity(id: r.id, name: r.name, icon: r.icon))
        .toList();
  }

  @override
  Future<int> insertCategory(CategoryEntity category) => _db
      .into(_db.categoriesTable)
      .insert(
        CategoriesTableCompanion.insert(
          name: category.name,
          icon: Value(category.icon),
        ),
      );

  @override
  Future<void> deleteCategory(int id) async {
    await (_db.delete(_db.categoriesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> seedPresets(
    List<RecipeEntity> recipes,
    List<CategoryEntity> categories,
  ) {
    return _db.transaction(() async {
      for (final cat in categories) {
        await _db
            .into(_db.categoriesTable)
            .insert(
              CategoriesTableCompanion.insert(
                name: cat.name,
                icon: Value(cat.icon),
              ),
            );
      }
      for (final recipe in recipes) {
        await insertRecipe(recipe);
      }
    });
  }

  @override
  Future<bool> hasSeededPresets() async {
    final query = _db.selectOnly(_db.recipesTable)
      ..addColumns([_db.recipesTable.id.count()])
      ..where(_db.recipesTable.isPreset.equals(true));
    final result = await query.getSingle();
    final count = result.read(_db.recipesTable.id.count()) ?? 0;
    return count > 0;
  }

  Future<void> _insertIngredients(
    int recipeId,
    List<IngredientEntity> ingredients,
  ) async {
    for (var i = 0; i < ingredients.length; i++) {
      final ing = ingredients[i];
      await _db
          .into(_db.ingredientsTable)
          .insert(
            IngredientsTableCompanion.insert(
              recipeId: recipeId,
              name: ing.name,
              amount: ing.amount,
              unit: Value(ing.unit),
              sortOrder: Value(i),
            ),
          );
    }
  }

  Future<RecipeEntity> _rowToEntity(RecipesTableData row) async {
    final ingredientRows =
        await (_db.select(_db.ingredientsTable)
              ..where((t) => t.recipeId.equals(row.id))
              ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
            .get();
    final ingredients = ingredientRows
        .map(
          (r) => IngredientEntity(name: r.name, amount: r.amount, unit: r.unit),
        )
        .toList();
    final steps = (jsonDecode(row.steps) as List).cast<String>();
    return RecipeEntity(
      id: row.id,
      name: row.name,
      categoryId: row.categoryId ?? 0,
      ingredients: ingredients,
      steps: steps,
      memo: row.memo,
      isFavorite: row.isFavorite,
      isPreset: row.isPreset,
      createdAt: row.createdAt,
    );
  }
}

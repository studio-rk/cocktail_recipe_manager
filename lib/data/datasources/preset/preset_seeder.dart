import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/entities/recipe_entity.dart';
import '../../../domain/entities/ingredient_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/repositories/recipe_repository.dart';

class PresetSeeder {
  final RecipeRepository _repository;

  PresetSeeder(this._repository);

  Future<void> seedIfNeeded() async {
    final hasSeeded = await _repository.hasSeededPresets();
    if (hasSeeded) return;

    final jsonStr = await rootBundle.loadString(
      'assets/presets/preset_recipes.json',
    );
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    final categories = (data['categories'] as List)
        .map(
          (c) => CategoryEntity(
            id: c['id'] as int,
            name: c['name'] as String,
            icon: c['icon'] as String,
          ),
        )
        .toList();

    final recipes = (data['recipes'] as List).map((r) {
      final ingredients = (r['ingredients'] as List)
          .map(
            (i) => IngredientEntity(
              name: i['name'] as String,
              amount: (i['amount'] as num).toDouble(),
              unit: i['unit'] as String,
            ),
          )
          .toList();
      return RecipeEntity(
        id: 0,
        name: r['name'] as String,
        categoryId: r['categoryId'] as int,
        ingredients: ingredients,
        steps: (r['steps'] as List).cast<String>(),
        memo: r['memo'] as String,
        isFavorite: false,
        isPreset: true,
        createdAt: DateTime.now(),
      );
    }).toList();

    await _repository.seedPresets(recipes, categories);
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recipe_entity.dart';
import 'ingredient_model.dart';
part 'recipe_model.freezed.dart';
part 'recipe_model.g.dart';

@freezed
class RecipeModel with _$RecipeModel {
  const factory RecipeModel({
    required int id,
    required String name,
    required int categoryId,
    required List<IngredientModel> ingredients,
    required List<String> steps,
    required String memo,
    required bool isFavorite,
    required bool isPreset,
    required DateTime createdAt,
  }) = _RecipeModel;

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  const RecipeModel._();

  RecipeEntity toEntity() => RecipeEntity(
        id: id,
        name: name,
        categoryId: categoryId,
        ingredients: ingredients.map((i) => i.toEntity()).toList(),
        steps: steps,
        memo: memo,
        isFavorite: isFavorite,
        isPreset: isPreset,
        createdAt: createdAt,
      );
}

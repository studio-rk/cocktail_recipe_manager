import 'package:freezed_annotation/freezed_annotation.dart';
import 'ingredient_entity.dart';
part 'recipe_entity.freezed.dart';

@freezed
class RecipeEntity with _$RecipeEntity {
  const factory RecipeEntity({
    required int id,
    required String name,
    required int categoryId,
    required List<IngredientEntity> ingredients,
    required List<String> steps,
    required String memo,
    required bool isFavorite,
    required bool isPreset,
    required DateTime createdAt,
  }) = _RecipeEntity;
}

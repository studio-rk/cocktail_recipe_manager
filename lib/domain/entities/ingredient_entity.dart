import 'package:freezed_annotation/freezed_annotation.dart';
part 'ingredient_entity.freezed.dart';

@freezed
class IngredientEntity with _$IngredientEntity {
  const factory IngredientEntity({
    required String name,
    required double amount,
    required String unit,
  }) = _IngredientEntity;
}

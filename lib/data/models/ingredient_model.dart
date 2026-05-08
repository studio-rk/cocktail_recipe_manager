import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ingredient_entity.dart';
part 'ingredient_model.freezed.dart';
part 'ingredient_model.g.dart';

@freezed
class IngredientModel with _$IngredientModel {
  const factory IngredientModel({
    required String name,
    required double amount,
    required String unit,
  }) = _IngredientModel;

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);

  const IngredientModel._();

  IngredientEntity toEntity() => IngredientEntity(
        name: name,
        amount: amount,
        unit: unit,
      );

  static IngredientModel fromEntity(IngredientEntity e) =>
      IngredientModel(name: e.name, amount: e.amount, unit: e.unit);
}

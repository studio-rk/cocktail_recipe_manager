// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeModelImpl _$$RecipeModelImplFromJson(Map<String, dynamic> json) =>
    _$RecipeModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      memo: json['memo'] as String,
      isFavorite: json['isFavorite'] as bool,
      isPreset: json['isPreset'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RecipeModelImplToJson(_$RecipeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'memo': instance.memo,
      'isFavorite': instance.isFavorite,
      'isPreset': instance.isPreset,
      'createdAt': instance.createdAt.toIso8601String(),
    };

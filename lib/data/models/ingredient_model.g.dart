// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IngredientModelImpl _$$IngredientModelImplFromJson(
  Map<String, dynamic> json,
) => _$IngredientModelImpl(
  name: json['name'] as String,
  amount: (json['amount'] as num).toDouble(),
  unit: json['unit'] as String,
);

Map<String, dynamic> _$$IngredientModelImplToJson(
  _$IngredientModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'amount': instance.amount,
  'unit': instance.unit,
};

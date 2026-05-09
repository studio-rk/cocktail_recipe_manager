import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/category_entity.dart';
part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String name,
    required String icon,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  const CategoryModel._();

  CategoryEntity toEntity() => CategoryEntity(id: id, name: name, icon: icon);
}

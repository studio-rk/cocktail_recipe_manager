// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) {
  return _RecipeModel.fromJson(json);
}

/// @nodoc
mixin _$RecipeModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  List<IngredientModel> get ingredients => throw _privateConstructorUsedError;
  List<String> get steps => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isPreset => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecipeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeModelCopyWith<RecipeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeModelCopyWith<$Res> {
  factory $RecipeModelCopyWith(
    RecipeModel value,
    $Res Function(RecipeModel) then,
  ) = _$RecipeModelCopyWithImpl<$Res, RecipeModel>;
  @useResult
  $Res call({
    int id,
    String name,
    int categoryId,
    List<IngredientModel> ingredients,
    List<String> steps,
    String memo,
    bool isFavorite,
    bool isPreset,
    DateTime createdAt,
  });
}

/// @nodoc
class _$RecipeModelCopyWithImpl<$Res, $Val extends RecipeModel>
    implements $RecipeModelCopyWith<$Res> {
  _$RecipeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? categoryId = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? memo = null,
    Object? isFavorite = null,
    Object? isPreset = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            ingredients: null == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                      as List<IngredientModel>,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            memo: null == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPreset: null == isPreset
                ? _value.isPreset
                : isPreset // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecipeModelImplCopyWith<$Res>
    implements $RecipeModelCopyWith<$Res> {
  factory _$$RecipeModelImplCopyWith(
    _$RecipeModelImpl value,
    $Res Function(_$RecipeModelImpl) then,
  ) = __$$RecipeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    int categoryId,
    List<IngredientModel> ingredients,
    List<String> steps,
    String memo,
    bool isFavorite,
    bool isPreset,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$RecipeModelImplCopyWithImpl<$Res>
    extends _$RecipeModelCopyWithImpl<$Res, _$RecipeModelImpl>
    implements _$$RecipeModelImplCopyWith<$Res> {
  __$$RecipeModelImplCopyWithImpl(
    _$RecipeModelImpl _value,
    $Res Function(_$RecipeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecipeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? categoryId = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? memo = null,
    Object? isFavorite = null,
    Object? isPreset = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RecipeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        ingredients: null == ingredients
            ? _value._ingredients
            : ingredients // ignore: cast_nullable_to_non_nullable
                  as List<IngredientModel>,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        memo: null == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPreset: null == isPreset
            ? _value.isPreset
            : isPreset // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeModelImpl extends _RecipeModel {
  const _$RecipeModelImpl({
    required this.id,
    required this.name,
    required this.categoryId,
    required final List<IngredientModel> ingredients,
    required final List<String> steps,
    required this.memo,
    required this.isFavorite,
    required this.isPreset,
    required this.createdAt,
  }) : _ingredients = ingredients,
       _steps = steps,
       super._();

  factory _$RecipeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int categoryId;
  final List<IngredientModel> _ingredients;
  @override
  List<IngredientModel> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<String> _steps;
  @override
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final String memo;
  @override
  final bool isFavorite;
  @override
  final bool isPreset;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RecipeModel(id: $id, name: $name, categoryId: $categoryId, ingredients: $ingredients, steps: $steps, memo: $memo, isFavorite: $isFavorite, isPreset: $isPreset, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._ingredients,
              _ingredients,
            ) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isPreset, isPreset) ||
                other.isPreset == isPreset) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    categoryId,
    const DeepCollectionEquality().hash(_ingredients),
    const DeepCollectionEquality().hash(_steps),
    memo,
    isFavorite,
    isPreset,
    createdAt,
  );

  /// Create a copy of RecipeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeModelImplCopyWith<_$RecipeModelImpl> get copyWith =>
      __$$RecipeModelImplCopyWithImpl<_$RecipeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeModelImplToJson(this);
  }
}

abstract class _RecipeModel extends RecipeModel {
  const factory _RecipeModel({
    required final int id,
    required final String name,
    required final int categoryId,
    required final List<IngredientModel> ingredients,
    required final List<String> steps,
    required final String memo,
    required final bool isFavorite,
    required final bool isPreset,
    required final DateTime createdAt,
  }) = _$RecipeModelImpl;
  const _RecipeModel._() : super._();

  factory _RecipeModel.fromJson(Map<String, dynamic> json) =
      _$RecipeModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get categoryId;
  @override
  List<IngredientModel> get ingredients;
  @override
  List<String> get steps;
  @override
  String get memo;
  @override
  bool get isFavorite;
  @override
  bool get isPreset;
  @override
  DateTime get createdAt;

  /// Create a copy of RecipeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeModelImplCopyWith<_$RecipeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category_entity.dart';
import 'recipe_provider.dart';

final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) {
  return ref.watch(recipeRepositoryProvider).getCategories();
});

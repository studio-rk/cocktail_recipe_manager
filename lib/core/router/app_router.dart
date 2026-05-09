import 'package:go_router/go_router.dart';
import '../../presentation/features/recipe_list/recipe_list_screen.dart';
import '../../presentation/features/recipe_detail/recipe_detail_screen.dart';
import '../../presentation/features/recipe_form/recipe_form_screen.dart';
import '../../presentation/features/category/category_screen.dart';
import '../../presentation/features/settings/settings_screen.dart';

class RouteParam {
  static const id = 'id';
}

enum AppRoute {
  recipeList('/'),
  recipeDetail('/recipe/:id'),
  recipeAdd('/recipe/add'),
  recipeEdit('/recipe/:id/edit'),
  category('/category'),
  settings('/settings');

  const AppRoute(this.path);
  final String path;

  String build({Map<String, String> params = const {}}) {
    var result = path;
    params.forEach((k, v) => result = result.replaceAll(':$k', v));
    return result;
  }

  static String detail(int id) =>
      recipeDetail.build(params: {RouteParam.id: '$id'});
  static String edit(int id) =>
      recipeEdit.build(params: {RouteParam.id: '$id'});
}

final appRouter = GoRouter(
  initialLocation: AppRoute.recipeList.path,
  routes: [
    GoRoute(
      path: AppRoute.recipeList.path,
      builder: (_, __) => const RecipeListScreen(),
    ),
    GoRoute(
      path: AppRoute.recipeAdd.path,
      builder: (_, __) => const RecipeFormScreen(),
    ),
    GoRoute(
      path: AppRoute.recipeDetail.path,
      builder: (_, state) => RecipeDetailScreen(
        recipeId: int.parse(state.pathParameters[RouteParam.id]!),
      ),
    ),
    GoRoute(
      path: AppRoute.recipeEdit.path,
      builder: (_, state) => RecipeFormScreen(
        recipeId: int.parse(state.pathParameters[RouteParam.id]!),
      ),
    ),
    GoRoute(
      path: AppRoute.category.path,
      builder: (_, __) => const CategoryScreen(),
    ),
    GoRoute(
      path: AppRoute.settings.path,
      builder: (_, __) => const SettingsScreen(),
    ),
  ],
);

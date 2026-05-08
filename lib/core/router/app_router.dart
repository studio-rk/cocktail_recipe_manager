import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

enum AppRoute {
  recipeList('/'),
  recipeDetail('/recipe/:id'),
  recipeAdd('/recipe/add'),
  recipeEdit('/recipe/:id/edit'),
  category('/category'),
  settings('/settings');

  const AppRoute(this.path);
  final String path;
}

final appRouter = GoRouter(
  initialLocation: AppRoute.recipeList.path,
  routes: [
    GoRoute(
      path: AppRoute.recipeList.path,
      builder: (_, __) => const Scaffold(body: Center(child: Text('Recipe List'))),
    ),
    GoRoute(
      path: AppRoute.recipeAdd.path,
      builder: (_, __) => const Scaffold(body: Center(child: Text('Add Recipe'))),
    ),
    GoRoute(
      path: AppRoute.recipeDetail.path,
      builder: (_, state) => Scaffold(
        body: Center(child: Text('Recipe ${state.pathParameters["id"]}')),
      ),
    ),
    GoRoute(
      path: AppRoute.recipeEdit.path,
      builder: (_, state) => Scaffold(
        body: Center(child: Text('Edit Recipe ${state.pathParameters["id"]}')),
      ),
    ),
    GoRoute(
      path: AppRoute.category.path,
      builder: (_, __) => const Scaffold(body: Center(child: Text('Category'))),
    ),
    GoRoute(
      path: AppRoute.settings.path,
      builder: (_, __) => const Scaffold(body: Center(child: Text('Settings'))),
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/database/app_database.dart';
import 'data/repositories/repositories.dart';
import 'data/datasources/preset/preset_seeder.dart';
import 'presentation/providers/recipe_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await PresetSeeder(RecipeRepositoryImpl(db)).seedIfNeeded();
  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const CocktailBookApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/database/app_database.dart';
import 'data/repositories/repositories.dart';
import 'data/datasources/preset/preset_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final repo = RecipeRepositoryImpl(db);
  await PresetSeeder(repo).seedIfNeeded();
  await db.close();
  runApp(const ProviderScope(child: CocktailBookApp()));
}

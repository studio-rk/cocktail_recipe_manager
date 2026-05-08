import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/categories_table.dart';
import 'tables/recipes_table.dart';
import 'tables/ingredients_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [CategoriesTable, RecipesTable, IngredientsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'cocktail_book.db'));
    return NativeDatabase.createInBackground(file);
  });
}

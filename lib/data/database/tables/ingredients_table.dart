import 'package:drift/drift.dart';
import 'recipes_table.dart';

class IngredientsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(RecipesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  RealColumn get amount => real()();
  TextColumn get unit => text().withDefault(const Constant('ml'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

import 'package:drift/drift.dart';
import 'categories_table.dart';

class RecipesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get categoryId => integer().nullable().references(CategoriesTable, #id)();
  TextColumn get steps => text().withDefault(const Constant('[]'))();
  TextColumn get memo => text().withDefault(const Constant(''))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isPreset => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

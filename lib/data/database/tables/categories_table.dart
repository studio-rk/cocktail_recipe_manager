import 'package:drift/drift.dart';

class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get icon => text().withDefault(const Constant('🍹'))();
}

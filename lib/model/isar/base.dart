import 'package:isar/isar.dart';

class Base {
  Base({
    this.id,
    this.isarUpdatedAt,
    this.isarCreatedAt,
    this.isarDeletedAt,
  });
  Id? id;
  DateTime? isarUpdatedAt;
  DateTime? isarCreatedAt;
  DateTime? isarDeletedAt;
}

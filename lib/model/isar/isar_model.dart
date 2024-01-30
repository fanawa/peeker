import 'package:idz/model/isar/base.dart';
import 'package:isar/isar.dart';

part 'isar_model.g.dart';

/* --------------------------
         Item
   -------------------------- */
@collection
class Item implements Base {
  Item({
    this.id,
    this.name,
    this.phoneNumber,
    this.url,
    this.description,
    this.fileName,
    this.isarUpdatedAt,
    this.isarCreatedAt,
    this.isarDeletedAt,
  });
  @override
  Id? id;
  String? name;
  String? phoneNumber;
  String? url;
  String? description;
  String? fileName;
  @override
  DateTime? isarCreatedAt;
  @override
  DateTime? isarDeletedAt;
  @override
  DateTime? isarUpdatedAt;
}

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
    this.displayOrder,
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
  int? displayOrder;
  @override
  DateTime? isarCreatedAt;
  @override
  DateTime? isarDeletedAt;
  @override
  DateTime? isarUpdatedAt;

  Item copyWith({
    Id? id,
    String? name,
    String? phoneNumber,
    String? url,
    String? description,
    String? fileName,
    int? displayOrder,
    DateTime? isarCreatedAt,
    DateTime? isarDeletedAt,
    DateTime? isarUpdatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      url: url ?? this.url,
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      displayOrder: displayOrder ?? this.displayOrder,
      isarCreatedAt: isarCreatedAt ?? this.isarCreatedAt,
      isarDeletedAt: isarDeletedAt ?? this.isarDeletedAt,
      isarUpdatedAt: isarUpdatedAt ?? this.isarUpdatedAt,
    );
  }
}

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

  final IsarLinks<PhoneNumber> phoneNumbers = IsarLinks<PhoneNumber>();

  Item copyWith({
    Id? id,
    String? name,
    String? phoneNumber,
    IsarLinks<PhoneNumber>? phoneNumbers,
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

@collection
class PhoneNumber implements Base {
  PhoneNumber({
    this.id,
    required this.number,
    this.contactName,
    this.isarUpdatedAt,
    this.isarCreatedAt,
    this.isarDeletedAt,
  });

  @override
  Id? id;
  String number;
  String? contactName;
  @override
  DateTime? isarCreatedAt;
  @override
  DateTime? isarDeletedAt;
  @override
  DateTime? isarUpdatedAt;

  @Backlink(to: 'phoneNumbers')
  final IsarLink<Item> item = IsarLink<Item>();

  PhoneNumber copyWith({
    Id? id,
    String? number,
    String? contactName,
    DateTime? isarCreatedAt,
    DateTime? isarDeletedAt,
    DateTime? isarUpdatedAt,
  }) {
    return PhoneNumber(
      id: id ?? this.id,
      number: number ?? this.number,
      contactName: contactName ?? this.contactName,
      isarCreatedAt: isarCreatedAt ?? this.isarCreatedAt,
      isarDeletedAt: isarDeletedAt ?? this.isarDeletedAt,
      isarUpdatedAt: isarUpdatedAt ?? this.isarUpdatedAt,
    );
  }
}

@collection
class FileName implements Base {
  FileName({
    this.id,
    required this.fileName,
    this.isarUpdatedAt,
    this.isarCreatedAt,
    this.isarDeletedAt,
  });

  @override
  Id? id;
  String fileName;
  @override
  DateTime? isarCreatedAt;
  @override
  DateTime? isarDeletedAt;
  @override
  DateTime? isarUpdatedAt;

  final IsarLink<Item> item = IsarLink<Item>();
}

import 'package:isar/isar.dart';
import 'package:peeker/model/isar/base.dart';

part 'isar_model.g.dart';


/* --------------------------
         Setting
   -------------------------- */
@collection
class Settings {
  Id id = Isar.autoIncrement; // 自動インクリメントのID
  bool isList = true; // デフォルトはリスト表示
}

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
  final IsarLinks<FileName> fileNames = IsarLinks<FileName>();

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
    required this.itemId,
    this.isarUpdatedAt,
    this.isarCreatedAt,
    this.isarDeletedAt,
  });

  @override
  Id? id;
  String number;
  String? contactName;
  int itemId;
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
    int? itemId,
    DateTime? isarCreatedAt,
    DateTime? isarDeletedAt,
    DateTime? isarUpdatedAt,
  }) {
    return PhoneNumber(
      id: id ?? this.id,
      number: number ?? this.number,
      contactName: contactName ?? this.contactName,
      itemId: itemId ?? this.itemId,
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
    required this.itemId,
    this.isarUpdatedAt,
    this.isarCreatedAt,
    this.isarDeletedAt,
  });

  @override
  Id? id;
  String fileName;
  int itemId;
  @override
  DateTime? isarCreatedAt;
  @override
  DateTime? isarDeletedAt;
  @override
  DateTime? isarUpdatedAt;

  @Backlink(to: 'fileNames')
  final IsarLink<Item> item = IsarLink<Item>();
}

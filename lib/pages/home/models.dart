import 'dart:io';

import 'package:idz/model/isar/isar_model.dart';

class ItemData {
  ItemData({
    required this.item,
    this.imagePath,
  });

  final Item item;
  final String? imagePath;

  ItemData copyWith({Item? item, String? imagePath}) {
    return ItemData(
      item: item ?? this.item.copyWith(),
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

import 'dart:io';

import 'package:idz/model/isar/isar_model.dart';

class ItemData {
  ItemData({
    required this.item,
    required this.imagePaths,
  });

  final Item item;
  final List<String> imagePaths;

  ItemData copyWith({Item? item, List<String>? imagePaths}) {
    return ItemData(
      item: item ?? this.item.copyWith(),
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}

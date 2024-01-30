import 'dart:io';

import 'package:idz/model/isar/isar_model.dart';

class ItemData {
  ItemData({
    required this.item,
    this.imagePath,
  });

  Item item;
  String? imagePath;
}

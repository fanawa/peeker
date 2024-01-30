import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> isarProvider({String? dirPath}) async {
  // TODO(a): 生体認証時時にdeviceIdを登録
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final String? deviceId = await storage.read(key: 'deviceId');

  // TODO(a): deiceIdもデータベース名に追加する  ex: 'IDz_$deviceId'
  Isar? isar = Isar.getInstance('IDz_');

  if (isar != null) {
    return isar;
  }

  final Directory defaultDir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    name: 'IDz_',
    inspector: true,
    <CollectionSchema<dynamic>>[
      ItemSchema,
    ],
    directory: dirPath ?? defaultDir.path,
  );
  return isar;
}

import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peeker/model/isar/isar_model.dart';

Future<Isar> isarProvider({String? dirPath}) async {
  // TODO(a): 生体認証時時にdeviceIdを登録
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final String? deviceId = await storage.read(key: 'deviceId');
  final String instanceName = 'PEEKER_$deviceId';

  // TODO(a): deiceIdもデータベース名に追加する  ex: 'IDz_$deviceId'
  Isar? isar = Isar.getInstance('IDz_');

  if (isar != null) {
    return isar;
  }

  final Directory defaultDir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    name: instanceName,
    inspector: true,
    <CollectionSchema<dynamic>>[
      ItemSchema,
      PhoneNumberSchema,
      FileNameSchema,
      SettingsSchema,
    ],
    directory: dirPath ?? defaultDir.path,
  );
  return isar;
}

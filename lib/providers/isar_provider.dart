import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> isarProvider({String? dirPath}) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final String? deviceId = await storage.read(key: 'deviceId');
  final String instanceName = 'IDz_$deviceId';

  Isar? isar = Isar.getInstance(instanceName);

  if (isar != null) {
    return isar;
  }

  final Directory defaultDir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    name: 'IDz_',
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

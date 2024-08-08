import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:idz/pages/home/models.dart';
import 'package:idz/pages/top/top_page_controller.dart';
import 'package:idz/providers/isar_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HomePageController extends GetxController {
  final TopPageController controller = Get.find();

  RxList<ItemData> items = RxList<ItemData>();
  Rxn<XFile?> selectedPicture = Rxn<XFile?>();
  Rxn<XFile?> previewPicture = Rxn<XFile?>();
  RxBool isList = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchItemData();
    await loadSettings();
    update();
  }

  Future<void> loadSettings() async {
    final Isar isar = await isarProvider();
    final settings = await isar.settings.where().findFirst();
    if (settings != null) {
      isList.value = settings.isList;
    }
  }

  Future<void> saveSettings() async {
    final Isar isar = await isarProvider();
    final settings = await isar.settings.where().findFirst() ?? Settings();
    settings.isList = isList.value;
    await isar.writeTxn(() async {
      await isar.settings.put(settings);
    });
  }

  /// アプリ内フォルダに画像を保管
  /// isarにはファイル名で保管する(保存領域までのパスが変動するため)
  Future<String?> saveImageToFileSystem(
    XFile imageData,
  ) async {
    try {
      final String fileName =
          'IDz_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String storePath = (await getApplicationDocumentsDirectory()).path;
      final String imagePath = '$storePath/$fileName';
      await imageData.saveTo(imagePath);
      return fileName;
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not save image client Api: $e');
      }
      return null;
    }
  }

  //**
  //  Isar
  //*/

  /// Item データ取得
  Future<List<ItemData>> fetchItemData() async {
    Isar? isar;
    List<ItemData> itemData = <ItemData>[];
    try {
      isar = await isarProvider();
      final List<Item>? queryResult = await isar.writeTxn(
        () async {
          return await isar?.items.where().sortByDisplayOrder().findAll();
        },
      );

      if (queryResult != null) {
        for (final Item item in queryResult) {
          // 各Itemについて、リンクされたphoneNumbersを明示的に読み込む
          await isar.phoneNumbers
              .filter()
              .itemIdEqualTo(item.id!)
              .findAll()
              .then((List<PhoneNumber> phoneNumbers) {
            item.phoneNumbers.addAll(phoneNumbers);
          });

          // 各Itemについて、リンクされたfileNamesを明示的に読み込む
          await isar.fileNames
              .filter()
              .itemIdEqualTo(item.id!)
              .findAll()
              .then((List<FileName> fileNames) {
            item.fileNames.addAll(fileNames);
          });
        }
      }

      final String storePath = (await getApplicationDocumentsDirectory()).path;

      itemData = queryResult!
          .map((Item item) {
            // ファイル名からフルパスを生成
            final List<String> imagePaths =
                item.fileNames.map((FileName fileName) {
              final String imagePath =
                  fileName.fileName == null || fileName.fileName == ''
                      ? ''
                      : p.join(storePath, fileName.fileName);
              if (!File(imagePath).existsSync()) {
                debugPrint('ファイルが存在しません: $imagePath');
              }
              return imagePath;
            }).toList();

            return ItemData(item: item, imagePaths: imagePaths);
          })
          .where((ItemData? item) => item != null)
          .cast<ItemData>()
          .toList();

      return items.value = itemData;
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not get Building client Api: $e');
      }
    }
    return itemData;
  }

  Future<bool> deleteItem(int itemId) async {
    Isar? isar;
    try {
      isar = await isarProvider();
      isar.writeTxn(() async {
        await isar?.items.delete(itemId);
      });
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not delete item client Api: $e');
        return false;
      }
    }
    return false;
  }

  // displayOrder更新処理
  Future<void> updateDisplayOrder(List<ItemData> itemDataList) async {
    final Isar isar = await isarProvider();
    await isar.writeTxn(
      () async {
        for (final ItemData itemData in itemDataList) {
          await isar.items.put(itemData.item);
        }
      },
    );
  }
}

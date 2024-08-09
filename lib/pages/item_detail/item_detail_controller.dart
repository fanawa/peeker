import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:peeker/model/isar/isar_model.dart';
import 'package:peeker/pages/home/models.dart';
import 'package:peeker/pages/top/top_page_controller.dart';
import 'package:peeker/providers/isar_provider.dart';
import 'package:peeker/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ItemDetailPageController extends GetxController {
  final TopPageController topPageController = Get.find();

  Isar? isar;
  Rxn<ItemData> itemData = Rxn<ItemData>();
  Rxn<XFile?> selectedPicture = Rxn<XFile?>();
  Rxn<XFile?> previewPicture = Rxn<XFile?>();
  RxInt imageIndex = 0.obs;

  @override
  void onInit() {
    itemData.value = Get.arguments as ItemData;
    super.onInit();
  }

  void updateItemData(ItemData updatedData) {
    itemData.value = updatedData;
    update();
  }

  void setImageIndex(int index) {
    imageIndex.value = index;
  }

  /// Item データ取得
  Future<ItemData?> fetchItemData(int itemId) async {
    Isar? isar;
    try {
      isar = await isarProvider();
      final Item? item = await isar.items.get(itemId);
      await isar.phoneNumbers
          .filter()
          .itemIdEqualTo(item!.id!)
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

      final String nowDocumentPath =
          (await getApplicationDocumentsDirectory()).path;

      final List<String> imagePaths = item.fileNames.map((FileName fileName) {
        final String imagePath = p.join(nowDocumentPath, fileName.fileName);
        if (!File(imagePath).existsSync()) {
          debugPrint('ファイルが存在しません: $imagePath');
        }
        return imagePath;
      }).toList();

      return ItemData(item: item, imagePaths: imagePaths);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not fetch item client Api: $e');
        return null;
      }
    }
    return null;
  }

  Future<bool> deleteItem(int itemId) async {
    Isar? isar;
    try {
      isar = await isarProvider();
      await isar.writeTxn(() async {
        await isar?.phoneNumbers.filter().itemIdEqualTo(itemId).deleteAll();
        await isar?.fileNames.filter().itemIdEqualTo(itemId).deleteAll();

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

  Future<bool> call() async {
    final Uri callLaunchUri = Uri(
      scheme: 'tel',
      path: itemData.value!.item.phoneNumber,
    );
    final bool canLaunch = await canLaunchUrl(callLaunchUri);
    if (canLaunch) {
      return launchUrl(callLaunchUri);
    } else {
      return false;
    }
  }

  Future<void> accessWeb() async {
    final String url = itemData.value!.item.url!;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> onTapImage(String uri) async {
    await Get.toNamed<void>(
      Routes.PHOTO_VIEW_PAGE,
      arguments: uri,
    );
    topPageController.isVisibleBottomNav.value = true;
  }

  /// アプリ内フォルダに画像を保管
  /// isarにはファイル名で保管する(保存領域までのパスが変動するため)
  Future<String?> saveImageToFileSystem(
    XFile imageData,
  ) async {
    try {
      final String fileName =
          'PEEKER_image_${DateTime.now().millisecondsSinceEpoch}.png';
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
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:idz/pages/home/models.dart';
import 'package:idz/pages/top/top_page_controller.dart';
import 'package:idz/providers/isar_provider.dart';
import 'package:idz/utils/environment_variables.dart';
import 'package:idz/utils/image_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EditItemPageController extends GetxController {
  final TopPageController controller = Get.find();

  Rxn<ItemData> itemData = Rxn<ItemData>();
  Rxn<XFile?> selectedPicture = Rxn<XFile?>();
  Rxn<XFile?> previewPicture = Rxn<XFile?>();

  String? previewPicturePath;

  // フォームの初期値を保存する変数
  late final ItemData initialItemData;
  // フォームが変更されたかどうかを追跡する変数
  RxBool isFormChanged = false.obs;

  @override
  void onInit() {
    itemData.value = Get.arguments as ItemData;
    previewPicturePath = itemData.value!.imagePath;

    // コピー
    initialItemData = itemData.value!.copyWith();

    super.onInit();
  }

  void checkFormChanges(GlobalKey<FormBuilderState> fbKey) {
    // FormBuilderのキーを使用して現在のフォームの値を取得
    final Map<String, dynamic> currentValues = fbKey.currentState!.value;

    // 初期データと現在のフォームの値を比較
    final bool hasChanged =
        initialItemData.item.name != currentValues['name'] ||
            initialItemData.item.phoneNumber != currentValues['phoneNumber'] ||
            initialItemData.item.url != currentValues['url'] ||
            initialItemData.item.description != currentValues['description'] ||
            // 画像の変更も考慮する
            (previewPicture.value != null &&
                initialItemData.imagePath != previewPicturePath);

    // 変更があれば true、なければ false をセット
    isFormChanged.value = hasChanged;
    // UIを更新するためにGetxのupdateメソッドを呼び出す
    update();
  }

  /// 画像選択
  Future<void> selectPicture(BuildContext context) async {
    {
      selectedPicture.value = null;

      final XFile? selectedFile =
          await ImageSelector.showBottomSheetMenu(context);
      if (selectedFile == null) {
        return;
      }

      if (await selectedFile.length() > 10000000) {
        if (context.mounted) {
          await FlutterPlatformAlert.showAlert(
            windowTitle: 'エラー',
            text: '画像サイズが大き過ぎます。\n10MB以下の画像を選択してください。',
          );
        }
        return;
      }
      final List<int> headerBytes = await selectedFile.openRead(0, 12).first;
      final String? mimeType = lookupMimeType(
        p.basenameWithoutExtension(selectedFile.path),
        headerBytes: headerBytes,
      );
      if (EnvironmentVariables.allowedMimeType.contains(mimeType)) {
        selectedPicture.value = selectedFile;
        update();
      } else {
        if (context.mounted) {
          await FlutterPlatformAlert.showAlert(
            windowTitle: 'エラー',
            text: '選択されたファイルは画像ではありません。\n画像ファイルを選択してください。',
          );
        } else {
          await FlutterPlatformAlert.showAlert(
            windowTitle: 'Error',
            text:
                'The selected file is not an image. \nPlease select an image file.',
          );
        }
      }
    }
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

  Future<bool> updateItem(
    String? name,
    String? phoneNumber,
    String? url,
    String? description,
    String? fileName,
  ) async {
    Isar? isar;
    isar = await isarProvider();
    final Item? updated =
        await isar.items.get(itemData.value!.item.id!.toInt());
    updated!.name = name;
    updated.phoneNumber = phoneNumber;
    updated.url = url;
    updated.description = description;
    updated.fileName = fileName;
    updated.isarUpdatedAt = DateTime.now();
    try {
      isar.writeTxn(
        () async {
          await isar?.items.put(updated);
        },
      );
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not update ItemDetail client Api: $e');
      }
      return false;
    }
  }

  /// Item データ取得
  Future<ItemData?> fetchItemData(int itemId) async {
    Isar? isar;
    try {
      isar = await isarProvider();
      final Item? item = await isar.items.get(itemId);

      final String nowDocumentPath =
          (await getApplicationDocumentsDirectory()).path;

      final String imagePath = item!.fileName == null || item.fileName == ''
          ? ''
          : File(p.join(nowDocumentPath, item.fileName)).path;
      debugPrint('imagePath: $imagePath');
      return ItemData(item: item, imagePath: imagePath);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not fetch item client Api: $e');
        return null;
      }
    }
    return null;
  }
}

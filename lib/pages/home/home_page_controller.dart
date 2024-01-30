import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class HomePageController extends GetxController {
  final TopPageController controller = Get.find();

  RxList<ItemData> items = RxList<ItemData>();
  Rxn<XFile?> selectedPicture = Rxn<XFile?>();
  Rxn<XFile?> previewPicture = Rxn<XFile?>();

  // List<Informations> data = <Informations>[
  //   Informations(title: '運転免許証'),
  //   Informations(title: '健康保険証 A'),
  //   Informations(title: '健康保険証 B'),
  //   Informations(title: '健康保険証 C'),
  //   Informations(title: '自動車保険'),
  //   Informations(title: '図書館'),
  //   Informations(title: '社員証'),
  // ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchItemData();
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
        debugPrint(
            ' selectedPicture.value.path: ${selectedPicture.value!.path}');
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

  //**
  //  Isar
  //*/

  // Item 追加
  Future<void> addItem(
    String name,
    String? phoneNumber,
    String? url,
    String? description,
    String? fileName,
  ) async {
    final Isar isar = await isarProvider();
    final Item input = Item()
      ..name = name
      ..phoneNumber = phoneNumber ?? ''
      ..url = url ?? ''
      ..description = description ?? ''
      ..fileName = fileName ?? ''
      ..isarCreatedAt = DateTime.now()
      ..isarUpdatedAt = DateTime.now();
    try {
      await isar.writeTxn(
        () async {
          await isar.items.put(input);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Could not create Item client Api: $e');
      }
      rethrow;
    }
  }

  Future<List<ItemData>> fetchItemData() async {
    Isar? isar;
    List<ItemData> itemData = <ItemData>[];
    try {
      isar = await isarProvider();
      final List<Item>? queryResult = await isar.writeTxn(
        () async {
          return await isar?.items.where().findAll();
        },
      );

      final String nowDocumentPath =
          (await getApplicationDocumentsDirectory()).path;

      itemData = queryResult!.map(
        (Item item) {
          final String filePath =
              File(p.join(nowDocumentPath, item.fileName)).path;
          debugPrint('filePath: $filePath');
          return ItemData(item: item, imagePath: filePath);
        },
      ).toList();

      return items.value = itemData;
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not get Building client Api: $e');
      }
    }
    return itemData;
  }

  // TODO(a): displayOrder更新処理
}

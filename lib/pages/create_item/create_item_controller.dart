import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:idz/pages/top/top_page_controller.dart';
import 'package:idz/providers/isar_provider.dart';
import 'package:idz/utils/environment_variables.dart';
import 'package:idz/utils/image_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CreateItemPageController extends GetxController {
  final TopPageController controller = Get.find();

  // 連絡先
  List<Map<String, dynamic>>? contactFields = <Map<String, dynamic>>[
    <String, String>{'contactName': '', 'phoneNumber': ''},
  ];

  Rxn<XFile?> selectedPicture = Rxn<XFile?>();
  Rxn<XFile?> previewPicture = Rxn<XFile?>();

  // 複数画像
  RxList<XFile?> selectedPictures = RxList<XFile?>();

  // 画像を追加するメソッド
  void addPicture(XFile file) {
    selectedPictures.add(file);
    update();
  }

  // 画像を削除するメソッド
  // void removePicture(XFile file) {
  //   selectedPictures.remove(file);
  //   update();
  // }

  // インデックスで画像を削除するメソッド
  void removePictureAtIndex(int index) {
    if (index >= 0 && index < selectedPictures.length) {
      selectedPictures.removeAt(index);
      debugPrint('selectedPictures: $selectedPictures');
      update();
    }
  }

  // nullを除外した新しいリストを作成するメソッド
  List<XFile> getSelectedPictures() {
    return selectedPictures
        .where((XFile? file) => file != null)
        .cast<XFile>()
        .toList();
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

  // 画像選択(複数)
  Future<void> selectPictures(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images != null) {
      selectedPictures.addAll(images);
      update();
      debugPrint('selectedPictures: ${selectedPictures.toString()}');
    }
  }

  //// 消す
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

  /// アプリ内フォルダに複数画像を保管
  /// isarにはファイル名で保管する(保存領域までのパスが変動するため)
  Future<List<String>> saveImagesToFileSystem(List<XFile> images) async {
    final List<String> fileNames = <String>[];
    for (XFile image in images) {
      final String fileName =
          'IDz_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String storePath = (await getApplicationDocumentsDirectory()).path;
      final String imagePath = '$storePath/$fileName';
      await image.saveTo(imagePath);
      fileNames.add(fileName);
    }
    return fileNames;
  }

  // 連絡先フォーム追加
  void addContactField() {
    contactFields!.add(<String, String>{
      'contactName': '',
      'phoneNumber': '',
    });
    update();
  }

  // 連絡先フォーム削除
  void removeContactField(int index, GlobalKey<FormBuilderState> fbKey) {
    if (contactFields != null && index < contactFields!.length) {
      contactFields!.removeAt(index);
      update();

      // FormBuilderの状態を更新
      final Map<String, dynamic> currentValues =
          Map<String, dynamic>.from(fbKey.currentState!.value);
      final Map<String, dynamic> newValues = <String, dynamic>{};

      // 削除されたインデックス以降のフィールド名を更新
      for (int i = index; i < contactFields!.length; i++) {
        newValues['contactName_$i'] =
            currentValues['contactName_${i + 1}'] ?? '';
        newValues['phoneNumber_$i'] =
            currentValues['phoneNumber_${i + 1}'] ?? '';
      }

      // 最後のフィールドを削除
      newValues.remove('contactName_${contactFields!.length}');
      newValues.remove('phoneNumber_${contactFields!.length}');

      // FormBuilderの状態をパッチ
      fbKey.currentState!.patchValue(newValues);
    }
  }

//**
//  Isar
//*/

// Item 作成後に PhoneNumber 追加
  // Future<bool> createItemWithPhoneNumbers(
  //   String name,
  //   String? url,
  //   String? description,
  //   String? fileName,
  // ) async {
  //   final int? itemId = await createItem(name, url, description, fileName);
  //   if (itemId != null) {
  //     debugPrint('contactFields: $contactFields');
  //     // contactFieldsの中のすべての連絡先情報をデータベースに追加
  //     for (final Map<String, dynamic> contact in contactFields!) {
  //       final String contactName = contact['contactName'].toString();
  //       final String phoneNumber = contact['phoneNumber'].toString();
  //       if (contactName.isNotEmpty && phoneNumber.isNotEmpty) {
  //         await createPhoneNumbers(itemId, contactName, phoneNumber);
  //       }
  //     }
  //     return true;
  //   }
  //   return false;
  // }
  Future<bool> createItemWithPhoneNumbers(
    String name,
    String? url,
    String? description,
    List<String>? fileNames,
  ) async {
    final int? itemId = await createItem(name, url, description);
    if (itemId != null) {
      debugPrint('contactFields: $contactFields');
      // contactFieldsの中のすべての連絡先情報をデータベースに追加
      for (final Map<String, dynamic> contact in contactFields!) {
        final String contactName = contact['contactName'].toString();
        final String phoneNumber = contact['phoneNumber'].toString();
        if (contactName.isNotEmpty && phoneNumber.isNotEmpty) {
          await createPhoneNumbers(itemId, contactName, phoneNumber);
        }
      }

      // fileNamesの中のすべてのファイル名をデータベースに追加
      if (fileNames != null) {
        for (final String fileName in fileNames) {
          await createFileNames(itemId, fileName);
        }
      }

      return true;
    }
    return false;
  }

  // Item 追加
  Future<int?> createItem(
    String name,
    String? url,
    String? description,
  ) async {
    final Isar isar = await isarProvider();
    final int maxOrder = await _getMaxDisplayOrder(isar);
    final Item input = Item()
      ..name = name
      ..url = url ?? ''
      ..description = description ?? ''
      ..displayOrder = maxOrder
      ..isarCreatedAt = DateTime.now()
      ..isarUpdatedAt = DateTime.now();
    int? itemId;
    try {
      itemId = await isar.writeTxn(() async {
        return isar.items.put(input);
      });
      debugPrint('Item created with ID: $itemId');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Could not create Item client Api: $e');
      }
    }
    return itemId;
  }

  // phoneNumber追加
  Future<void> createPhoneNumbers(
    int itemId,
    String? contactName,
    String phoneNumber,
  ) async {
    final Isar isar = await isarProvider();
    try {
      await isar.writeTxn(
        () async {
          final Item? item = await isar.items.get(itemId);
          if (item == null) {
            debugPrint('Item not found for ID: $itemId');
            return;
          }

          // PhoneNumbersに登録
          final PhoneNumber input =
              PhoneNumber(number: phoneNumber, itemId: itemId)
                ..contactName = contactName
                ..isarCreatedAt = DateTime.now()
                ..isarUpdatedAt = DateTime.now()
                ..item.value = item;

          await isar.phoneNumbers.put(input); // PhoneNumber を保存

          // オプション：itemにphoneNumberをリンクする場合
          item.phoneNumbers.add(input);
          await item.phoneNumbers.save();
        },
      );
      debugPrint('PhoneNumber added successfully');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Could not create PhoneNumber client Api: $e');
      }
    }
  }

  // 画像ファイル名登録
  Future<void> createFileNames(int itemId, String fileName) async {
    final Isar isar = await isarProvider();
    try {
      await isar.writeTxn(
        () async {
          final Item? item = await isar.items.get(itemId);
          if (item == null) {
            debugPrint('Item not found for ID: $itemId');
            return;
          }

          final FileName input = FileName(fileName: fileName, itemId: itemId)
            ..isarCreatedAt = DateTime.now()
            ..isarUpdatedAt = DateTime.now()
            ..item.value = item;

          await isar.fileNames.put(input);

          item.fileNames.add(input);
          await item.fileNames.save();
        },
      );
      debugPrint('FileName added successfully');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Could not create FileName client Api: $e');
      }
    }
  }

// displayOrderの最大値取得
  Future<int> _getMaxDisplayOrder(Isar isar) async {
    final List<Item?> items =
        await isar.items.where().sortByDisplayOrderDesc().limit(1).findAll();

    if (items.isNotEmpty) {
      return items.first!.displayOrder!;
    } else {
      return 0; // デフォルト値、データが存在しない場合
    }
  }
}

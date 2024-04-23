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

  List<Map<String, dynamic>> contactFields = <Map<String, dynamic>>[];

  @override
  void onInit() {
    itemData.value = Get.arguments as ItemData;
    previewPicturePath = itemData.value!.imagePath;
    // 連絡先が存在しない場合、デフォルトの連絡先を追加
    if (itemData.value!.item.phoneNumbers.isEmpty) {
      contactFields.add(<String, dynamic>{
        'contactName': '',
        'phoneNumber': '',
        'id': null, // 新規の連絡先として扱うためidはnull
      });
    } else {
      contactFields =
          itemData.value!.item.phoneNumbers.map((PhoneNumber phone) {
        return <String, String>{
          'contactName': phone.contactName ?? '',
          'phoneNumber': phone.number,
          'id': phone.id.toString(),
        };
      }).toList();
    }
    initialItemData = itemData.value!.copyWith();

    update();

    super.onInit();
  }

  void addContactField() {
    contactFields.add(<String, String>{
      'contactName': '',
      'phoneNumber': '',
    });
    update();
  }

  void removeContactField(int index, GlobalKey<FormBuilderState> fbKey) {
    if (contactFields != null && index < contactFields.length) {
      contactFields.removeAt(index);
      update(); // UIを更新

      // FormBuilderの状態を更新
      final Map<String, dynamic> newValues = <String, dynamic>{};
      for (int i = 0; i < contactFields.length; i++) {
        newValues['contactName_$i'] = contactFields[i]['contactName'];
        newValues['phoneNumber_$i'] = contactFields[i]['phoneNumber'];
      }

      // FormBuilderの状態を新しい値で更新
      fbKey.currentState!.patchValue(newValues);
    }
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

// Item 作成後に PhoneNumber 追加
  Future<bool> updateItemWithPhoneNumbers(
    String name,
    String? url,
    String? description,
    String? fileName,
  ) async {
    final int? itemId = await updateItem(name, url, description, fileName);
    if (itemId != null) {
      final Isar isar = await isarProvider();
      return isar.writeTxn(() async {
        final List<PhoneNumber> existingPhoneNumbers =
            await isar.phoneNumbers.filter().itemIdEqualTo(itemId).findAll();
        final Map<int, PhoneNumber> existingIdToPhoneNumber =
            <int, PhoneNumber>{
          for (final PhoneNumber phone in existingPhoneNumbers) phone.id!: phone
        };

        final Set<int> processedIds = <int>{};

        for (final Map<String, dynamic> contact in contactFields) {
          final String contactName = contact['contactName'].toString();
          final String phoneNumber = contact['phoneNumber'].toString();
          final int? contactId = contact['id'] != null
              ? int.tryParse(contact['id'].toString())
              : null;

          if (contactId != null &&
              existingIdToPhoneNumber.containsKey(contactId)) {
            // Update existing contact
            final PhoneNumber existingPhone =
                existingIdToPhoneNumber[contactId]!;
            existingPhone.contactName = contactName;
            existingPhone.number = phoneNumber;
            await isar.phoneNumbers.put(existingPhone);
            processedIds.add(contactId);
          } else {
            // Add new contact
            final PhoneNumber newPhoneNumber = PhoneNumber(
              number: phoneNumber,
              contactName: contactName,
              itemId: itemId,
            );
            await isar.phoneNumbers.put(newPhoneNumber);
          }
        }

        // Remove unprocessed existing contacts
        for (final int id in existingIdToPhoneNumber.keys) {
          if (!processedIds.contains(id)) {
            await isar.phoneNumbers.delete(id);
          }
        }

        return true;
      });
    } else {
      debugPrint('Failed to update item or item ID was null');
      return false;
    }
  }

  Future<void> updatePhoneNumber(
      int itemId, String? contactName, String phoneNumber) async {
    final Isar isar = await isarProvider();
    try {
      // すべての操作を単一のトランザクション内で実行
      await isar.writeTxn(() async {
        final Item? item = await isar.items.get(itemId);
        if (item == null) {
          debugPrint('Item not found for ID: $itemId');
          return;
        }

        // 既存のPhoneNumberをすべて削除
        await item.phoneNumbers.load(); // 必要に応じてリンクを明示的にロード
        final List<PhoneNumber> existingPhoneNumbers =
            item.phoneNumbers.toList();
        for (final PhoneNumber existingPhoneNumber in existingPhoneNumbers) {
          await isar.phoneNumbers.delete(existingPhoneNumber.id!);
        }

        // 新しいPhoneNumberを作成
        final PhoneNumber newPhoneNumber = PhoneNumber(
          number: phoneNumber,
          itemId: itemId,
          contactName: contactName, // ここでコンタクト名も設定
        );
        await isar.phoneNumbers.put(newPhoneNumber);
      });
      debugPrint('PhoneNumber updated successfully');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Could not update PhoneNumber: $e');
      }
    }
  }

  Future<int?> updateItem(
    String? name,
    String? url,
    String? description,
    String? fileName,
  ) async {
    Isar? isar;
    isar = await isarProvider();
    int? itemId;
    try {
      final Item? updated =
          await isar.items.get(itemData.value!.item.id!.toInt());
      if (updated != null) {
        updated.name = name;
        updated.url = url;
        updated.description = description;
        updated.fileName = fileName;
        updated.isarUpdatedAt = DateTime.now();
        await isar.writeTxn(
          () async {
            itemId = await isar?.items.put(updated);
          },
        );
        return itemId;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not update ItemDetail client Api: $e');
      }
      return null;
    }
    return null;
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

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
  RxList<XFile> selectedPictures = <XFile>[].obs;
  RxList<String> previewPicturePaths = <String>[].obs;
  RxList<String> removedImagePaths = <String>[].obs; // 削除された画像のパス

  late final ItemData initialItemData;

  RxBool isFormChanged = false.obs;

  List<Map<String, dynamic>> contactFields = <Map<String, dynamic>>[];

  @override
  void onInit() {
    super.onInit();
    itemData.value = Get.arguments as ItemData;
    previewPicturePaths.value = itemData.value!.imagePaths;
    selectedPictures
        .addAll(itemData.value!.imagePaths.map((String path) => XFile(path)));

    if (itemData.value!.item.phoneNumbers.isEmpty) {
      contactFields.add(<String, dynamic>{
        'contactName': '',
        'phoneNumber': '',
        'id': null,
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
      update();

      final Map<String, dynamic> newValues = <String, dynamic>{};
      for (int i = 0; i < contactFields.length; i++) {
        newValues['contactName_$i'] = contactFields[i]['contactName'];
        newValues['phoneNumber_$i'] = contactFields[i]['phoneNumber'];
      }

      fbKey.currentState!.patchValue(newValues);
    }
  }

  void checkFormChanges(GlobalKey<FormBuilderState> fbKey) {
    final Map<String, dynamic> currentValues = fbKey.currentState!.value;

    final bool hasChanged =
        initialItemData.item.name != currentValues['name'] ||
            initialItemData.item.url != currentValues['url'] ||
            initialItemData.item.description != currentValues['description'] ||
            selectedPictures.isNotEmpty ||
            removedImagePaths.isNotEmpty;

    isFormChanged.value = hasChanged;
    update();
  }

  Future<void> selectPicture(
      BuildContext context, GlobalKey<FormBuilderState> fbKey) async {
    final List<XFile>? selectedFiles =
        await ImageSelector.showBottomSheetMenu(context);
    if (selectedFiles == null || selectedFiles.isEmpty) {
      return;
    }

    for (final XFile selectedFile in selectedFiles) {
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
        selectedPictures.add(selectedFile);
        previewPicturePaths.add(selectedFile.path);
      } else {
        if (context.mounted) {
          await FlutterPlatformAlert.showAlert(
            windowTitle: 'エラー',
            text: '選択されたファイルは画像ではありません。\n画像ファイルを選択してください。',
          );
        }
      }
    }
    checkFormChanges(fbKey);
    update();
  }

  Future<String?> saveImageToFileSystem(XFile imageData) async {
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

  Future<bool> updateItemWithPhoneNumbers(
    String name,
    String? url,
    String? description,
    List<String>? fileNames,
  ) async {
    final int? itemId = await updateItem(name, url, description, fileNames);
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

          // どちらかが入力されている場合のみ保存
          if (contactName.isNotEmpty || phoneNumber.isNotEmpty) {
            if (contactId != null &&
                existingIdToPhoneNumber.containsKey(contactId)) {
              final PhoneNumber existingPhone =
                  existingIdToPhoneNumber[contactId]!;
              existingPhone.contactName = contactName;
              existingPhone.number = phoneNumber;
              await isar.phoneNumbers.put(existingPhone);
              processedIds.add(contactId);
            } else {
              final PhoneNumber newPhoneNumber = PhoneNumber(
                number: phoneNumber,
                contactName: contactName,
                itemId: itemId,
              );
              await isar.phoneNumbers.put(newPhoneNumber);
            }
          }
        }

        for (final int id in existingIdToPhoneNumber.keys) {
          if (!processedIds.contains(id)) {
            await isar.phoneNumbers.delete(id);
          }
        }

        // 新しい画像パスを保存
        if (fileNames != null && fileNames.isNotEmpty) {
          await isar.fileNames.filter().itemIdEqualTo(itemId).deleteAll();
          for (final String fileName in fileNames) {
            final FileName newFileName =
                FileName(fileName: fileName, itemId: itemId);
            await isar.fileNames.put(newFileName);
          }
        }

        // 削除された画像のパスを削除
        for (final String removedPath in removedImagePaths) {
          final String removedFileName = p.basename(removedPath);
          await isar.fileNames
              .filter()
              .fileNameEqualTo(removedFileName)
              .deleteAll();
        }

        return true;
      });
    } else {
      debugPrint('Failed to update item or item ID was null');
      return false;
    }
  }

  Future<int?> updateItem(
    String? name,
    String? url,
    String? description,
    List<String>? fileNames,
  ) async {
    final Isar isar = await isarProvider();
    if (isar == null) {
      debugPrint('Isar instance is null');
      return null;
    }

    int? itemId;
    try {
      final Item? updated =
          await isar.items.get(itemData.value!.item.id!.toInt());
      if (updated != null) {
        updated.name = name;
        updated.url = url;
        updated.description = description;

        updated.fileNames.clear();
        if (fileNames != null) {
          for (final String path in fileNames) {
            final FileName fileName =
                FileName(fileName: path, itemId: updated.id!);
            updated.fileNames.add(fileName);
          }
        }

        updated.isarUpdatedAt = DateTime.now();
        await isar.writeTxn(
          () async {
            itemId = await isar.items.put(updated);
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

  Future<ItemData?> fetchItemData(int itemId) async {
    Isar? isar;
    try {
      isar = await isarProvider();
      final Item? item = await isar.items.get(itemId);
      await isar.phoneNumbers
          .filter()
          .itemIdEqualTo(item!.id!)
          .sortByIsarCreatedAt()
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

  void removeImage(int index, GlobalKey<FormBuilderState> fbKey) {
    if (index >= 0 && index < previewPicturePaths.length) {
      final String removedPath = previewPicturePaths[index];
      removedImagePaths.add(removedPath); // 削除された画像パスを保存
      previewPicturePaths.removeAt(index);
      selectedPictures.removeAt(index);
      checkFormChanges(fbKey);
      update();
    }
  }
}

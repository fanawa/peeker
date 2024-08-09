import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peeker/components/templates/item_information_form.dart';
import 'package:peeker/model/isar/isar_model.dart';
import 'package:peeker/pages/edit_item/edit_item_controller.dart';
import 'package:peeker/pages/home/models.dart';
import 'package:peeker/routes/app_pages.dart';

class EditItemPage extends StatelessWidget {
  EditItemPage({super.key});
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditItemPageController>(
      init: EditItemPageController(),
      builder: (EditItemPageController controller) {
        if (controller.itemData.value == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('エラー'),
            ),
            body: const Center(
              child: Text('データが存在しません。'),
            ),
          );
        }
        final ItemData itemData = controller.itemData.value!;
        final PhoneNumber firstPhoneNumber =
            itemData.item.phoneNumbers.isNotEmpty
                ? itemData.item.phoneNumbers.first
                : PhoneNumber(
                    contactName: '',
                    number: '',
                    itemId: itemData.item.id!,
                  );
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '編集',
              style: TextStyle(color: Colors.black),
            ),
            leadingWidth: 100,
            leading: TextButton(
              onPressed: () async {
                final bool isChanged = _fbKey.currentState!.isDirty ||
                    controller.isFormChanged.value;
                if (isChanged) {
                  final CustomButton result =
                      await FlutterPlatformAlert.showCustomAlert(
                    windowTitle: '変更内容を破棄しますか？',
                    text: '',
                    positiveButtonTitle: 'OK',
                    negativeButtonTitle: 'キャンセル',
                  );
                  if (!context.mounted) {
                    return;
                  }
                  switch (result) {
                    case CustomButton.positiveButton:
                      Navigator.of(context).pop<bool>(false);
                      controller.selectedPictures.clear();
                      break;
                    case CustomButton.negativeButton:
                      break;
                    default:
                      break;
                  }
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('キャンセル'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: !controller.isFormChanged.value
                    ? null
                    : () async {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          final String name =
                              _fbKey.currentState!.value['name'].toString();
                          final String url =
                              _fbKey.currentState!.value['url'].toString();
                          final String description = _fbKey
                              .currentState!.value['description']
                              .toString();

                          final List<Map<String, dynamic>> extractedContacts =
                              <Map<String, dynamic>>[];
                          for (int index = 0;
                              index < controller.contactFields!.length;
                              index++) {
                            final String contactName = _fbKey
                                .currentState!.value['contactName_$index']
                                .toString();
                            final String phoneNumber = _fbKey
                                .currentState!.value['phoneNumber_$index']
                                .toString();
                            if (contactName.isNotEmpty ||
                                phoneNumber.isNotEmpty) {
                              extractedContacts.add(<String, String>{
                                'contactName': contactName,
                                'phoneNumber': phoneNumber
                              });
                            }
                          }
                          controller.contactFields = extractedContacts;

                          final List<String> fileNames = <String>[];
                          for (final XFile picture
                              in controller.selectedPictures) {
                            final String? fileName =
                                await controller.saveImageToFileSystem(picture);
                            if (fileName != null) {
                              fileNames.add(fileName);
                            }
                          }

                          final bool success =
                              await controller.updateItemWithPhoneNumbers(
                            name,
                            url,
                            description,
                            fileNames,
                          );
                          if (success) {
                            final ItemData? updatedItemData = await controller
                                .fetchItemData(itemData.item.id!);
                            if (updatedItemData != null) {
                              if (context.mounted) {
                                Get.back<ItemData>(
                                    id: NavManager.getNavigationRouteId(
                                        Routes.HOME),
                                    result: updatedItemData);
                              }
                            } else {
                              if (kDebugMode) {
                                debugPrint('データがありません。');
                              }
                            }
                          } else {
                            if (kDebugMode) {
                              debugPrint('更新失敗しました');
                            }
                          }
                        }
                      },
                child: const Text('完了'),
              ),
            ],
          ),
          body: SafeArea(
            child: ItemInformationForm(
              fbKey: _fbKey,
              previewPicturePaths: controller.selectedPictures
                  .map((XFile? picture) => picture?.path ?? '')
                  .where((String path) => path.isNotEmpty)
                  .toList(),
              contactFields: controller.contactFields,
              initialValueName: itemData.item.name,
              initialValueContactName: firstPhoneNumber.contactName,
              initialValuePhoneNumber: firstPhoneNumber.number,
              initialValueUrl: itemData.item.url,
              initialValueDescription: itemData.item.description,
              onPressAdd: () {
                controller.addContactField();
              },
              onPressRemove: (int index) {
                controller.removeContactField(index, _fbKey);
              },
              onChanged: (_) {
                controller.checkFormChanges(_fbKey);
              },
              onTapAddImage: () async {
                await controller.selectPicture(context, _fbKey);
                if (!context.mounted) {
                  return;
                }
                controller.update();
              },
              onTapRemoveImage: (int index) {
                controller.removeImage(index, _fbKey);
                controller.update();
              },
              onTapCancel: () {},
            ),
          ),
        );
      },
    );
  }
}

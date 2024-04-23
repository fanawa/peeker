import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:idz/components/templates/item_information_form.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:idz/pages/edit_item/edit_item_controller.dart';
import 'package:idz/pages/home/models.dart';
import 'package:idz/routes/app_pages.dart';

class EditItemPage extends StatelessWidget {
  EditItemPage({super.key});
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditItemPageController>(
      init: EditItemPageController(),
      builder: (EditItemPageController controller) {
        // itemDataがnullかどうかをチェック
        if (controller.itemData.value == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('エラー'),
            ),
            body: Center(
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
                    itemId: itemData.item.id!); // 連絡先が空の場合のデフォルト値
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '編集',
              style: TextStyle(color: Colors.black),
            ),
            leadingWidth: 100,
            leading: TextButton(
              child: const Text(
                'キャンセル',
              ),
              onPressed: () async {
                final bool isChanged = _fbKey.currentState!.isDirty ||
                    controller.previewPicture.value != null;
                // 初期値と比較して変更があるか確認
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
                      // OK
                      // Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop<bool>(false);
                      controller.previewPicture.value = null;
                      break;
                    // キャンセル
                    case CustomButton.negativeButton:
                      Navigator.of(context).pop();
                      break;
                    default:
                      break;
                  }
                } else {
                  // 変更がなければ直接ダイアログを閉じる
                  Navigator.of(context).pop();
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                // 変更があれば true
                onPressed: !controller.isFormChanged.value
                    ? null
                    : () async {
                        // ボタンが押されたときの処理
                        // isFormChanged が false の場合、ボタンは非活性化されます。() async {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          final String name =
                              _fbKey.currentState!.value['name'] == null
                                  ? ''
                                  : _fbKey.currentState!.value['name']
                                      .toString();
                          final String url =
                              _fbKey.currentState!.value['url'] == null
                                  ? ''
                                  : _fbKey.currentState!.value['url']
                                      .toString();
                          final String description =
                              _fbKey.currentState!.value['description'] == null
                                  ? ''
                                  : _fbKey.currentState!.value['description']
                                      .toString();

                          // フォームからすべての連絡先フィールドを抽出
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
                            if (contactName.isNotEmpty &&
                                phoneNumber.isNotEmpty) {
                              extractedContacts.add(<String, String>{
                                'contactName': contactName,
                                'phoneNumber': phoneNumber
                              });
                            }
                          }
                          // 保存前にコントローラの連絡先フィールドを更新
                          controller.contactFields = extractedContacts;

                          final String? fileName =
                              controller.previewPicture.value == null
                                  ? itemData.imagePath
                                  : await controller.saveImageToFileSystem(
                                      controller.previewPicture.value!);
                          final bool success =
                              await controller.updateItemWithPhoneNumbers(
                            name,
                            url,
                            description,
                            fileName,
                          );
                          if (success) {
                            // データの更新が成功した場合、最新のデータを取得
                            final ItemData? updatedItemData = await controller
                                .fetchItemData(itemData.item.id!);
                            if (updatedItemData != null) {
                              // 成功した場合のみ、更新されたデータを戻り値として設定
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
                            // 更新に失敗した場合の処理
                            if (kDebugMode) {
                              debugPrint('更新失敗しました');
                            }
                          }
                        }
                      },
                child: const Text(
                  '完了',
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: ItemInformationForm(
              fbKey: _fbKey,
              previewPicturePath: controller.previewPicturePath,
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
              onChangedContactName: (String? value) {
                controller.update();
              },
              onChangedName: (_) {
                controller.checkFormChanges(_fbKey);
              },
              onChangedPhoneNumber: (_) {
                controller.checkFormChanges(_fbKey);
              },
              onChangedUrl: (_) {
                controller.checkFormChanges(_fbKey);
              },
              onChangedDescription: (_) {
                controller.checkFormChanges(_fbKey);
              },
              onTapCancel: () async {
                final bool isChanged = _fbKey.currentState!.isDirty;
                // 初期値と比較して変更があるか確認
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
                      // OK
                      Navigator.of(context, rootNavigator: true).pop();
                      controller.previewPicture.value = null;
                      break;
                    // キャンセル
                    case CustomButton.negativeButton:
                      Navigator.of(context).pop();
                      break;
                    default:
                      break;
                  }
                } else {
                  // 変更がなければ直接ダイアログを閉じる
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop();
                  controller.selectedPicture.value = null;
                }
              },
              onTapAddImage: () async {
                // 画像選択 or カメラ起動
                await controller.selectPicture(context);
                if (!context.mounted) {
                  return;
                }
                if (controller.selectedPicture.value != null) {
                  controller.previewPicture.value =
                      controller.selectedPicture.value;
                  controller.previewPicturePath =
                      controller.previewPicture.value!.path;
                  controller.selectedPicture.value = null;
                  controller.checkFormChanges(_fbKey);
                  controller.update();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

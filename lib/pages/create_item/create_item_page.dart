import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:idz/components/templates/item_information_form.dart';
import 'package:idz/pages/create_item/create_item_controller.dart';

class CreateItemPage extends StatelessWidget {
  CreateItemPage({super.key});
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateItemPageController>(
      init: CreateItemPageController(),
      builder: (CreateItemPageController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '新規作成',
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
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    final String name =
                        _fbKey.currentState!.value['name'] == null
                            ? ''
                            : _fbKey.currentState!.value['name'].toString();
                    final String contactName =
                        _fbKey.currentState!.value['contactName'] == null
                            ? ''
                            : _fbKey.currentState!.value['contactName']
                                .toString();
                    final String phoneNumber =
                        _fbKey.currentState!.value['phoneNumber'] == null
                            ? ''
                            : _fbKey.currentState!.value['phoneNumber']
                                .toString();
                    final String url = _fbKey.currentState!.value['url'] == null
                        ? ''
                        : _fbKey.currentState!.value['url'].toString();
                    final String description =
                        _fbKey.currentState!.value['description'] == null
                            ? ''
                            : _fbKey.currentState!.value['description']
                                .toString();

                    final String? fileName =
                        controller.previewPicture.value == null
                            ? ''
                            : await controller.saveImageToFileSystem(
                                controller.previewPicture.value!);

                    final bool result =
                        await controller.createItemWithPhoneNumbers(
                      name,
                      contactName,
                      phoneNumber,
                      url,
                      description,
                      fileName,
                    );
                    if (result != null) {
                      controller.previewPicture.value = null;
                      if (context.mounted) {
                        // Navigator.of(context).pop<bool>(true);
                        // Get.back(result: true, canPop: true);
                        Navigator.of(context).pop(true);
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
              previewPicturePath: controller.previewPicture.value?.path,
              onTapCancel: () async {
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
                  controller.selectedPicture.value = null;
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

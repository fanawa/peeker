import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:peeker/components/templates/item_information_form.dart';
import 'package:peeker/pages/create_item/create_item_controller.dart';

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
                    controller.selectedPictures.isNotEmpty;
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
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    final String name =
                        _fbKey.currentState!.value['name']?.toString() ?? '';
                    final String url =
                        _fbKey.currentState!.value['url']?.toString() ?? '';
                    final String description =
                        _fbKey.currentState!.value['description']?.toString() ??
                            '';

                    final List<Map<String, dynamic>> extractedContacts =
                        <Map<String, dynamic>>[];
                    for (int index = 0;
                        index < (controller.contactFields?.length ?? 0);
                        index++) {
                      final String contactName = _fbKey
                              .currentState!.value['contactName_$index']
                              ?.toString() ??
                          '';
                      final String phoneNumber = _fbKey
                              .currentState!.value['phoneNumber_$index']
                              ?.toString() ??
                          '';
                      if (contactName.isNotEmpty || phoneNumber.isNotEmpty) {
                        extractedContacts.add(<String, String>{
                          'contactName': contactName,
                          'phoneNumber': phoneNumber,
                        });
                      }
                    }
                    controller.contactFields = extractedContacts;

                    final List<XFile> selectedPictures =
                        controller.getSelectedPictures();
                    final List<String> fileNames = await controller
                        .saveImagesToFileSystem(selectedPictures);

                    final bool result =
                        await controller.createItemWithPhoneNumbers(
                      name,
                      url,
                      description,
                      fileNames,
                    );
                    if (result) {
                      controller.selectedPictures.clear();
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
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
              contactFields:
                  controller.contactFields ?? <Map<String, dynamic>>[],
              onPressAdd: () {
                controller.addContactField();
              },
              onPressRemove: (int index) {
                controller.removeContactField(index, _fbKey);
              },
              onChanged: (_) {
                controller.update();
              },
              onTapAddImage: () async {
                await controller.selectPictures(context);
                if (!context.mounted) {
                  return;
                }
                controller.update();
              },
              onTapRemoveImage: (int index) {
                controller.removePictureAtIndex(index); // 修正
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

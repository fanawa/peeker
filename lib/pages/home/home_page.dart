import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:idz/components/templates/information_form_dialog.dart';
import 'package:idz/pages/home/home_page_controller.dart';
import 'package:idz/pages/home/models.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _fbKey.currentState?.save();
    return GetBuilder<HomePageController>(
      init: HomePageController(),
      builder: (HomePageController controller) {
        return Scaffold(
          key: key,
          appBar: AppBar(
            title: const Text(
              'Home',
              // style: TextStyle(color: Colors.black),
            ),
          ),
          body: SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                const SizedBox(height: 30),
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ReorderableGridView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        onReorder: (int oldIndex, int newIndex) {
                          // // 追加ボタンのインデックスを確認
                          if (oldIndex == controller.items.length ||
                              newIndex == controller.items.length) {
                            // 追加ボタンが並び替えの対象となる場合は何もしない
                            return;
                          }
                          final ItemData item =
                              controller.items.removeAt(oldIndex);
                          controller.items.insert(newIndex, item);
                          // TODO(a): displayOrder更新処理
                          controller.update();
                        },
                        itemCount: controller.items.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          debugPrint(
                              'controller.items.length: ${controller.items.length}');
                          if (index == controller.items.length) {
                            // 追加ボタン
                            return Card(
                              key: const ValueKey<String>('add_button'),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await InformationFormDialog.show(
                                    context,
                                    fbKey: _fbKey,
                                    title: 'funk',
                                    onTapCancel: () async {
                                      final bool isChanged =
                                          _fbKey.currentState!.isDirty ||
                                              controller.previewPicture.value !=
                                                  null;
                                      // 初期値と比較して変更があるか確認
                                      if (isChanged) {
                                        final CustomButton result =
                                            await FlutterPlatformAlert
                                                .showCustomAlert(
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
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            controller.previewPicture.value =
                                                null;
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
                                    onTapDone: () async {
                                      // TODO(a): 登録処理
                                      if (_fbKey.currentState!
                                          .saveAndValidate()) {
                                        final String name = _fbKey
                                            .currentState!.value['name']
                                            .toString();
                                        final String phoneNumber = _fbKey
                                            .currentState!.value['phoneNumber']
                                            .toString();
                                        final String url = _fbKey
                                            .currentState!.value['url']
                                            .toString();
                                        final String description = _fbKey
                                            .currentState!.value['description']
                                            .toString();

                                        final String? fileName =
                                            await controller
                                                .saveImageToFileSystem(
                                                    controller
                                                        .previewPicture.value!);

                                        await controller.addItem(
                                          name,
                                          phoneNumber,
                                          url,
                                          description,
                                          fileName,
                                        );
                                      }
                                    },
                                    onTapAddImage: () async {
                                      // 画像選択 or カメラ起動
                                      await controller.selectPicture(context);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      if (controller.selectedPicture.value !=
                                          null) {
                                        controller.previewPicture.value =
                                            controller.selectedPicture.value;
                                        controller.selectedPicture.value = null;
                                        controller.update();
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            // 登録済みカード
                            final ItemData row = controller.items[index];
                            debugPrint('row.image: ${row.imagePath}');
                            debugPrint(
                                'row.image.length: ${row.imagePath!.length}');
                            return Card(
                              key: Key(index.toString()),
                              child: GestureDetector(
                                onTap: () {
                                  // TODO(a): カード詳細画面へ
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        height: 100,
                                        child: PageView.builder(
                                          itemCount: 1, // TODO(a): listにしたい
                                          controller: PageController(
                                            viewportFraction: 0.8,
                                          ),
                                          itemBuilder: (
                                            BuildContext context,
                                            int horizontalIndex,
                                          ) {
                                            return Container(
                                              height: 100,
                                              width: 120,
                                              foregroundDecoration:
                                                  BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: row.item.fileName == null
                                                  ? Image.asset(
                                                      'assets/images/noimage.png',
                                                      // width: 72,
                                                      // height: 72,
                                                      fit: BoxFit.fitHeight,
                                                    )
                                                  : Image.file(
                                                      File(row.imagePath!),
                                                      // width: 72,
                                                      // height: 72,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        child: Text(
                                          row.item.name == 'null'
                                              ? ''
                                              : row.item.name!,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

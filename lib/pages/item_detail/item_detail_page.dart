import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:idz/components/templates/tel_error_dialog.dart';
import 'package:idz/pages/home/models.dart';
import 'package:idz/pages/item_detail/item_detail_controller.dart';
import 'package:idz/routes/app_pages.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemDetailPageController>(
      init: ItemDetailPageController(),
      builder: (ItemDetailPageController controller) {
        return SelectionArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                controller.itemData.value!.item.name!,
                textScaler: const TextScaler.linear(1),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 34.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red[300],
                    ),
                    onTap: () async {
                      final CustomButton result =
                          await FlutterPlatformAlert.showCustomAlert(
                        windowTitle: '削除しますか？',
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
                          final bool result = await controller
                              .deleteItem(controller.itemData.value!.item.id!);
                          if (result != null) {
                            controller.previewPicture.value = null;
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          }
                          break;
                        // キャンセル
                        case CustomButton.negativeButton:
                          break;
                        default:
                          break;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () async {
                      final dynamic result = await Get.toNamed<dynamic>(
                        Routes.EDIT_ITEM,
                        arguments: controller.itemData.value,
                        id: NavManager.getNavigationRouteId(Routes.HOME),
                      )!
                          .then(
                        (void value) async {
                          controller.itemData.value =
                              await controller.fetchItemData(
                                  controller.itemData.value!.item.id!);
                          controller.update();
                        },
                      );
                      ;
                      if (result is ItemData && result != null) {
                        controller.updateItemData(result);
                      }
                    },
                  ),
                ),
              ],
            ),
            body: SelectionArea(
              child: SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Container(
                      height: MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height
                          ? MediaQuery.of(context).size.height * 0.5
                          : MediaQuery.of(context).size.height * 0.28,
                      width: MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height
                          ? 130
                          : 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // foregroundDecoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      child: controller.itemData.value!.imagePath == null ||
                              controller.itemData.value!.imagePath == ''
                          ? Image.asset(
                              'assets/images/noimage.png',
                              fit: BoxFit.fitHeight,
                            )
                          : GestureDetector(
                              child: Image.file(
                                File(controller.itemData.value!.imagePath!),
                                fit: BoxFit.fitHeight,
                              ),
                              onTap: () async {
                                debugPrint('onTap()');
                                await controller.onTapImage(
                                    controller.itemData.value!.imagePath!);
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: controller.itemData.value!.item.url != '',
                          child: SizedBox(
                            height: 80,
                            width: 120,
                            child: GestureDetector(
                              onTap: () async {
                                await controller.accessWeb();
                              },
                              child: const Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.language,
                                      size: 32,
                                    ),
                                    Text(
                                      'Web',
                                      textScaler: TextScaler.linear(1),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // 電話番号
                        Visibility(
                          visible:
                              controller.itemData.value!.item.phoneNumber != '',
                          child: SizedBox(
                            height: 80,
                            width: 120,
                            child: GestureDetector(
                              onTap: () async {
                                return showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext builder) {
                                    return SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Wrap(
                                          children: <Widget>[
                                            Container(
                                              // height: 140,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  FilledButton(
                                                    style: ButtonStyle(
                                                      fixedSize:
                                                          MaterialStateProperty
                                                              .all<
                                                                      Size>(
                                                                  const Size
                                                                      .fromHeight(
                                                                      70)),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .lightBlue),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .grey[100]!),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        const TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(controller
                                                          .itemData
                                                          .value!
                                                          .item
                                                          .phoneNumber!),
                                                    ),
                                                    onPressed: () async {
                                                      final bool result =
                                                          await controller
                                                              .call();
                                                      if (context.mounted) {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      }
                                                      if (result == false) {
                                                        if (context.mounted) {
                                                          TelErrorDialog.show(
                                                            context,
                                                            message: '発信できません',
                                                            onTapOk: () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 70,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: FilledButton(
                                                style: ButtonStyle(
                                                  fixedSize:
                                                      MaterialStateProperty.all<
                                                              Size>(
                                                          const Size.fromHeight(
                                                              70)),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Colors.lightBlue),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Colors.grey[100]!),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Text('キャンセル'),
                                                ),
                                                onPressed: () async {
                                                  if (context.mounted) {
                                                    Navigator.of(
                                                      context,
                                                      rootNavigator: true,
                                                    ).pop();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      size: 32,
                                    ),
                                    Text(
                                      '電話',
                                      textScaler: TextScaler.linear(1),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: MediaQuery.of(context).size.width >
                                MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width * 0.1
                            : MediaQuery.of(context).size.height * 0.25,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            controller.itemData.value!.item.description!,
                            textScaler: const TextScaler.linear(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible:
                          controller.itemData.value!.item.phoneNumber != '',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FilledButton.tonalIcon(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size.fromHeight(60)),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey[100]!),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          icon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.phone),
                          ),
                          label: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.itemData.value!.item.phoneNumber!,
                              // style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                          onPressed: () async {
                            final bool result = await controller.call();
                            if (result == false) {
                              if (context.mounted) {
                                TelErrorDialog.show(
                                  context,
                                  message: '発信できません',
                                  onTapOk: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: controller.itemData.value!.item.url != '',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FilledButton.tonalIcon(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size.fromHeight(60)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlue),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey[100]!),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          icon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.language),
                          ),
                          label: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.itemData.value!.item.url!,
                              textScaler: const TextScaler.linear(1),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onPressed: () async {
                            await controller.accessWeb();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

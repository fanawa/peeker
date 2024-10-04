import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:peeker/components/templates/tel_error_dialog.dart';
import 'package:peeker/model/isar/isar_model.dart';
import 'package:peeker/pages/home/models.dart';
import 'package:peeker/pages/item_detail/item_detail_controller.dart';
import 'package:peeker/routes/app_pages.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemDetailPageController>(
      init: ItemDetailPageController(),
      builder: (ItemDetailPageController controller) {
        final PageController pageController =
            PageController(viewportFraction: 0.6);
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
                          ? MediaQuery.of(context).size.height * 0.3
                          : MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height
                          ? 130
                          : 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: PageView.builder(
                                controller: pageController,
                                itemCount: controller
                                        .itemData.value!.imagePaths.isNotEmpty
                                    ? controller
                                        .itemData.value!.imagePaths.length
                                    : 1,
                                onPageChanged: (int index) {
                                  controller.setImageIndex(index);
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  final String imagePath = controller
                                          .itemData.value!.imagePaths.isNotEmpty
                                      ? controller
                                          .itemData.value!.imagePaths[index]
                                      : 'assets/images/noimage.png';
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                    child: GestureDetector(
                                      onTap: imagePath !=
                                              'assets/images/noimage.png'
                                          ? () async {
                                              await controller
                                                  .onTapImage(imagePath);
                                            }
                                          : null,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: imagePath ==
                                                'assets/images/noimage.png'
                                            ? Image.asset(
                                                'assets/images/noimage.png',
                                                fit: BoxFit.fitHeight,
                                              )
                                            : Image.file(
                                                File(imagePath),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List<Widget>.generate(
                                controller.itemData.value!.imagePaths.length,
                                (int index) {
                                  return Obx(() {
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            controller.imageIndex.value == index
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 連絡先
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        spacing: 20,
                        children: <Widget>[
                          ...controller.itemData.value!.item.phoneNumbers
                              .toList()
                              .asMap()
                              .entries
                              .map<Widget>((MapEntry<int, PhoneNumber> entry) {
                            final int index = entry.key;
                            final PhoneNumber phoneNumber = entry.value;
                            return Column(
                              children: <Widget>[
                                if (index != 0)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 0.1,
                                    ),
                                  ),
                                // 連絡先間の区切り線
                                Visibility(
                                  visible: controller.itemData.value!.item
                                      .phoneNumbers.isNotEmpty,
                                  child: FilledButton(
                                    style: ButtonStyle(
                                        padding: WidgetStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            const EdgeInsets.only(left: 20)),
                                        fixedSize:
                                            WidgetStateProperty.all<Size>(
                                                const Size.fromHeight(60)),
                                        foregroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.blue),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.grey[100]!),
                                        textStyle: WidgetStateProperty.all(
                                          const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            phoneNumber.contactName ?? '',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            phoneNumber.number,
                                            style: const TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      final bool result = await controller
                                          .call(phoneNumber.number);
                                      if (result == false) {
                                        if (context.mounted) {
                                          TelErrorDialog.show(
                                            context,
                                            message: '発信できません',
                                            onTapOk: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          })
                        ],
                      ),
                    ),
                    // URL
                    Visibility(
                      visible: controller.itemData.value!.item.url != '',
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 20,
                          right: 20,
                        ),
                        child: FilledButton(
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              fixedSize: WidgetStateProperty.all<Size>(
                                  const Size.fromHeight(70)),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  Colors.lightBlue),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.grey[100]!),
                              textStyle: WidgetStateProperty.all(
                                const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          child: Align(
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 20,
                        right: 20,
                      ),
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
                          padding: const EdgeInsets.all(20.0),
                          child: SelectableText(
                            controller.itemData.value!.item.description!,
                            textScaler: const TextScaler.linear(1),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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

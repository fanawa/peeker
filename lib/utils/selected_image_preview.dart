import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idz/components/atoms/custom_circular_progress_indicator.dart';
import 'package:idz/themes/light_theme.dart';

/// 選択した画像のプレビュー
class SelectedImagePreview {
  static Future<Widget?> displayBottomSheet(
    BuildContext context, {
    String? selectedPicturePath,
    Future<void> Function()? onPressedAdd,
  }) async {
    final RxBool isLoading = RxBool(false);
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 60),
                  Obx(
                    () => Stack(
                      children: <Widget>[
                        Container(
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                            maxWidth: 300,
                          ),
                          child: Image.file(
                            File(selectedPicturePath!),
                            fit: BoxFit.fill,
                          ),
                        ),
                        if (isLoading.value)
                          const Positioned.fill(
                            child: Center(
                              child: CustomCircularProgressIndicator(),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SelectableText(
                        'キャンセル',
                        textScaler: const TextScaler.linear(1.0),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                        onTap: () {
                          selectedPicturePath = null;
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        onPressed: () async {
                          if (!isLoading.value) {
                            isLoading.value = true;
                            await onPressedAdd?.call().then((void value) async {
                              Navigator.pop(context);
                              isLoading.value = false;
                            });
                          }
                        },
                        child: const Text(
                          '登録',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

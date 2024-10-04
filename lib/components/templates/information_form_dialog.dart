import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:peeker/components/atoms/custom_circular_progress_indicator.dart';
import 'package:peeker/pages/home/home_page_controller.dart';

class InformationFormDialog {
  static Future<void> show(
    BuildContext context, {
    required GlobalKey<FormBuilderState> fbKey,
    required String title,
    required VoidCallback onTapCancel,
    required VoidCallback onTapDone,
    required VoidCallback onTapAddImage,
    String? selectedPicturePath,
    String? initialValueName,
    String? initialValuePhoneNumber,
    String? initialValueUrl,
    String? initialValueDescription,
    
  }) {
    final RxBool isLoading = RxBool(false);

    return showDialog<void>(
      useRootNavigator: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GetBuilder<HomePageController>(
          init: HomePageController(),
          builder: (HomePageController controller) {
            return AlertDialog(
              insetPadding: EdgeInsets.zero,
              elevation: 0,
              scrollable: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: MediaQuery.of(context).size.width >
                      MediaQuery.of(context).size.height
                  ? const EdgeInsets.all(6)
                  : EdgeInsets.zero,
              content: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 70),
                        Container(
                          constraints: const BoxConstraints(
                            maxHeight: 150,
                            maxWidth: 150,
                          ),
                          child: controller.previewPicture.value?.path == null
                              ? Container(color: Colors.grey[100])
                              : Image.file(
                                  File(controller.previewPicture.value!.path),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        if (isLoading.value)
                          const Positioned.fill(
                            child: Center(
                              child: CustomCircularProgressIndicator(),
                            ),
                          ),
                        const SizedBox(height: 6),
                        FilledButton.tonalIcon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.grey[100]!),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('写真を追加'),
                          onPressed: onTapAddImage,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            '名前',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: FormBuilder(
                            key: fbKey,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: FormBuilderTextField(
                                      name: 'name',
                                      initialValue: initialValueName ?? '',
                                      textAlign: TextAlign.start,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.multiline,
                                      validator: FormBuilderValidators.compose(
                                        <FormFieldValidator<String?>>[
                                          FormBuilderValidators.maxLength(40)
                                        ],
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        focusedBorder: InputBorder.none,
                                        filled: true,
                                        errorMaxLines: 3,
                                        border: InputBorder.none,
                                        hintText: '名前',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: const Text(
                                      '電話番号',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  FormBuilderTextField(
                                    name: 'phoneNumber',
                                    initialValue: initialValuePhoneNumber ?? '',
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.center,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.phone,
                                    validator: FormBuilderValidators.compose(
                                      <FormFieldValidator<String?>>[
                                        FormBuilderValidators.maxLength(20),
                                        FormBuilderValidators.integer(),
                                      ],
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      focusedBorder: InputBorder.none,
                                      filled: true,
                                      errorMaxLines: 3,
                                      border: InputBorder.none,
                                      hintText: '電話',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: const Text(
                                      'URL',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  FormBuilderTextField(
                                    name: 'url',
                                    initialValue: initialValueUrl ?? '',
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.center,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.url,
                                    validator: FormBuilderValidators.compose(
                                      <FormFieldValidator<String?>>[
                                        FormBuilderValidators.url(),
                                      ],
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      focusedBorder: InputBorder.none,
                                      filled: true,
                                      errorMaxLines: 3,
                                      border: InputBorder.none,
                                      hintText: 'URL',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: const Text(
                                      'メモ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  FormBuilderTextField(
                                    name: 'description',
                                    initialValue: initialValueDescription ?? '',
                                    minLines: 3,
                                    maxLines: null,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.center,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    validator: FormBuilderValidators.compose(
                                      <FormFieldValidator<String?>>[
                                        FormBuilderValidators.maxLength(200)
                                      ],
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      focusedBorder: InputBorder.none,
                                      errorMaxLines: 3,
                                      border: InputBorder.none,
                                      hintText: 'メモ',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Builder(builder: (BuildContext context) {
                          return Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 2.0),
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: onTapCancel,
                                child: const Text(
                                  'キャンセル',
                                ),
                              ),
                            ),
                          );
                        }),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              '新規登録',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(right: 2.0),
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: onTapDone,
                              child: const Text(
                                '完了',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

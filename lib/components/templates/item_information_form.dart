import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:idz/components/atoms/custom_circular_progress_indicator.dart';

class ItemInformationForm extends StatelessWidget {
  ItemInformationForm({
    Key? key,
    required this.fbKey,
    this.previewPicturePath,
    required this.onTapCancel,
    required this.onTapAddImage,
    this.initialValueName,
    this.initialValuePhoneNumber,
    this.initialValueUrl,
    this.initialValueDescription,
    this.onChangedName,
    this.onChangedPhoneNumber,
    this.onChangedUrl,
    this.onChangedDescription,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> fbKey;
  final String? previewPicturePath;
  final VoidCallback onTapCancel;
  final VoidCallback onTapAddImage;
  final String? initialValueName;
  final String? initialValuePhoneNumber;
  final String? initialValueUrl;
  final String? initialValueDescription;
  final void Function(String?)? onChangedName;
  final void Function(String?)? onChangedPhoneNumber;
  final void Function(String?)? onChangedUrl;
  final void Function(String?)? onChangedDescription;

  final RxBool isLoading = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 150,
                  maxWidth: 150,
                ),
                child: previewPicturePath == null || previewPicturePath == ''
                    ? Container(color: Colors.grey[100])
                    : Image.file(
                        File(previewPicturePath!),
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey[100]!),
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
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            onChanged: onChangedName,
                            validator: FormBuilderValidators.compose(
                              <FormFieldValidator<String?>>[
                                FormBuilderValidators.required(
                                  errorText: '必須項目です',
                                ),
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
                              hintStyle: TextStyle(color: Colors.grey),
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
                          onChanged: onChangedPhoneNumber,
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
                          onChanged: onChangedUrl,
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
                          onChanged: onChangedDescription,
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
      ],
    );
  }
}

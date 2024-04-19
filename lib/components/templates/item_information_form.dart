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
    this.initialValueContactName,
    this.initialValuePhoneNumber,
    this.initialValueUrl,
    this.initialValueDescription,
    this.onChangedName,
    this.onChangedContactName,
    this.onChangedPhoneNumber,
    this.onChangedUrl,
    this.onChangedDescription,
    this.contactFields,
    this.onPressRemove,
    this.onPressAdd,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> fbKey;
  final String? previewPicturePath;
  final VoidCallback onTapCancel;
  final VoidCallback onTapAddImage;
  final String? initialValueName;
  final String? initialValueContactName;
  final String? initialValuePhoneNumber;
  final String? initialValueUrl;
  final String? initialValueDescription;
  final void Function(String?)? onChangedName;
  final void Function(String?)? onChangedContactName;
  final void Function(String?)? onChangedPhoneNumber;
  final void Function(String?)? onChangedUrl;
  final void Function(String?)? onChangedDescription;

  final List<Map<String, dynamic>>? contactFields;
  final void Function(int)? onPressRemove;
  final void Function()? onPressAdd;

  final RxBool isLoading = RxBool(false);

  // List<Map<String, dynamic>> contactFields = [];

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
                            '連絡先',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        for (int i = 0; i < contactFields!.length; i++) ...[
                          _buildContactField(i, context),
                          if (i < contactFields!.length - 1)
                            const SizedBox(height: 10),
                        ],
                        if (contactFields!.isNotEmpty &&
                            (contactFields![0]['contactName'] != '' ||
                                contactFields![0]['phoneNumber'] != ''))
                          TextButton(
                            onPressed: onPressAdd,
                            child: const Text('連絡先を追加'),
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

  Widget _buildContactField(int index, BuildContext context) {
    final bool isLast = index == contactFields!.length - 1;
    final bool isFirst = index == 0;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  name: 'contactName_$index',
                  // initialValue: initialValueContactName ?? '',
                  initialValue: contactFields![index]['contactName'] == null ||
                          contactFields![index]['contactName'] == ''
                      ? ''
                      : contactFields![index]['contactName'].toString(),
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    contactFields![index]['contactName'] = value;
                    // update(); // Update the UI if necessary
                    onChangedContactName!.call(value);
                  },

                  validator: FormBuilderValidators.compose(
                    <FormFieldValidator<String?>>[
                      FormBuilderValidators.maxLength(20),
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
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 20,
                      ),
                      child: Text(
                        'ラベル', // Example prefix for Japan
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                  ),
                ),
                FormBuilderTextField(
                  name: 'phoneNumber_$index',
                  // initialValue: initialValuePhoneNumber ?? '',
                  initialValue: contactFields![index]['phoneNumber'].toString(),
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
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Text(
                        '電話番号',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isFirst || contactFields!.length > 1)
            Container(
              width: 50,
              color: Colors.grey[100],
              child: IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                onPressed: () => onPressRemove!(index), // Pass the index here
              ),
            ),
        ],
      ),
    );
  }
}

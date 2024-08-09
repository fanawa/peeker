import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:peeker/components/atoms/custom_circular_progress_indicator.dart';

class ItemInformationForm extends StatelessWidget {
  ItemInformationForm({
    Key? key,
    required this.fbKey,
    this.previewPicturePaths,
    required this.onTapCancel,
    required this.onTapAddImage,
    required this.onTapRemoveImage,
    this.initialValueName,
    this.initialValueContactName,
    this.initialValuePhoneNumber,
    this.initialValueUrl,
    this.initialValueDescription,
    this.onChanged,
    this.contactFields,
    this.onPressRemove,
    this.onPressAdd,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> fbKey;
  final List<String>? previewPicturePaths;
  final VoidCallback onTapCancel;
  final VoidCallback onTapAddImage;
  final void Function(int) onTapRemoveImage;
  final String? initialValueName;
  final String? initialValueContactName;
  final String? initialValuePhoneNumber;
  final String? initialValueUrl;
  final String? initialValueDescription;
  final void Function(String?)? onChanged;

  final List<Map<String, dynamic>>? contactFields;
  final void Function(int)? onPressRemove;
  final void Function()? onPressAdd;

  final RxBool isLoading = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: previewPicturePaths?.length ?? 1,
                  itemBuilder: (BuildContext context, int index) {
                    final String? path = previewPicturePaths?[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                'この画像を削除しますか？',
                                textAlign: TextAlign.center,
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('キャンセル'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onTapRemoveImage(index);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('削除'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: path == null || path == ''
                          ? Container(color: Colors.grey[100])
                          : Image.file(
                              File(path),
                              fit: BoxFit.fill,
                            ),
                    );
                  },
                ),
              ),
              Obx(
                () => isLoading.value
                    ? const Positioned.fill(
                        child: Center(
                          child: CustomCircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink(),
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
                            onChanged: onChanged,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                '連絡先',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                              Visibility(
                                visible: contactFields!.isNotEmpty &&
                                    (contactFields!.last['contactName'] != '' ||
                                        contactFields!.last['phoneNumber'] !=
                                            ''),
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline_sharp,
                                      size: 17,
                                      color: Colors.blue,
                                    ),
                                    onPressed: onPressAdd,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (int i = 0;
                            i < contactFields!.length;
                            i++) ...<Widget>[
                          _buildContactField(i, context),
                          if (i < contactFields!.length - 1)
                            const SizedBox(height: 10),
                        ],
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
                          onChanged: onChanged,
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
                          minLines: 6,
                          maxLines: null,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          onChanged: onChanged,
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
    final bool isFirst = index == 0;
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'contactName_$index',
                      initialValue:
                          contactFields![index]['contactName'] == null ||
                                  contactFields![index]['contactName'] == ''
                              ? ''
                              : contactFields![index]['contactName'].toString(),
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      onChanged: (String? value) {
                        contactFields![index]['contactName'] = value;
                        onChanged!.call(value);
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
                            'ラベル',
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
                      initialValue:
                          contactFields![index]['phoneNumber'].toString(),
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onChanged: (String? value) {
                        contactFields![index]['phoneNumber'] = value;
                        onChanged!.call(value);
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
                      size: 18,
                    ),
                    onPressed: () => onPressRemove!(index),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

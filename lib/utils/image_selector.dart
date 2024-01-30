import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// 画像選択時のBottomSheet
class ImageSelector {
  static Future<XFile?> showBottomSheetMenu(BuildContext context) {
    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              children: <Widget>[
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: const Text(
                          '写真を撮る',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                            imageQuality: 70,
                            maxWidth: 500,
                            source: ImageSource.camera,
                          );
                          if (context.mounted) {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(photo);
                          }
                        },
                      ),
                      const Divider(thickness: 0.5),
                      ListTile(
                        title: const Text(
                          'ライブラリから選択',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              imageQuality: 70,
                              maxWidth: 500,
                              source: ImageSource.gallery);
                          if (context.mounted) {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(image);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: const Text(
                      'キャンセル',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
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
  }
}

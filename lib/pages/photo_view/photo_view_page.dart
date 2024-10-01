import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peeker/pages/photo_view/photo_view_page_controller.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String picture = Get.arguments.toString();
    return GetBuilder<PhotoViewPageController>(
      global: false,
      init: PhotoViewPageController(),
      builder: (PhotoViewPageController controller) => Stack(
        children: <Widget>[
          PhotoView(
            imageProvider:
                picture.startsWith('http://') || picture.startsWith('https://')
                    ? NetworkImage(picture) as ImageProvider
                    : FileImage(File(picture)),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: MediaQuery.of(context).size.height >
                      MediaQuery.of(context).size.width
                  ? const EdgeInsets.only(top: 55, right: 10)
                  : const EdgeInsets.only(top: 55, right: 50),
              child: Builder(
                builder: (BuildContext context) {
                  return Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

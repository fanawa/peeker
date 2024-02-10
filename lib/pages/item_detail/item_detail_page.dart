import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idz/pages/item_detail/item_detail_controller.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemDetailPageController>(
      init: ItemDetailPageController(),
      builder: (ItemDetailPageController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Item Detail',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SafeArea(
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
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: controller.itemData.value!.imagePath == null
                    ? Image.asset(
                        'assets/images/noimage.png',
                        fit: BoxFit.fitHeight,
                      )
                    : Image.file(
                        File(controller.itemData.value!.imagePath!),
                        fit: BoxFit.fitHeight,
                      ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: SizedBox(
                  child: Text(
                    controller.itemData.value!.item.name!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: SizedBox(
                  child: Text(
                    controller.itemData.value!.item.description!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FilledButton.tonalIcon(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(70)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey[100]!),
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
                  child: Text(controller.itemData.value!.item.phoneNumber!),
                ),
                onPressed: () async {
                  await controller.call();
                },
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(70)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey[100]!),
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
                    controller.itemData.value!.item.url! * 5,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onPressed: () async {
                  await controller.call();
                },
              ),
            ],
          )),
        );
      },
    );
  }
}

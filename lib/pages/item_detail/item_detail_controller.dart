import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:idz/pages/home/models.dart';
import 'package:idz/pages/top/top_page_controller.dart';
import 'package:idz/providers/isar_provider.dart';
import 'package:isar/isar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ItemDetailPageController extends GetxController {
  final TopPageController controller = Get.find();

  Isar? isar;
  Rxn<ItemData> itemData = Rxn<ItemData>();

  @override
  void onInit() {
    itemData.value = Get.arguments as ItemData;
    debugPrint('itemData.value: ${itemData.value}');
    super.onInit();
  }

  Future<void> updateItem(
    String? name,
    String? phoneNumber,
    String? url,
    String? description,
  ) async {
    isar = await isarProvider();
    final Item? updated =
        await isar?.items.get(itemData.value!.item.id!.toInt());
    updated!.name = name;
    updated.phoneNumber = phoneNumber;
    updated.url = url;
    updated.description = description;
    updated.isarUpdatedAt = DateTime.now();
    try {
      isar?.writeTxn(
        () async {
          await isar?.items.put(updated);
        },
      );

      // TODOa): 画像のupdate処理
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not update ItemDetail client Api: $e');
      }
    }
  }

  Future<void> deleteItem(int itemId) async {
    isar = await isarProvider();
    isar!.writeTxn(() async {
      return await isar?.items.delete(itemId);
    });
  }

  Future<bool> call() async {
    final Uri callLaunchUri = Uri(
      scheme: 'tel',
      path: itemData.value!.item.phoneNumber,
    );
    final bool canLaunch = await canLaunchUrl(callLaunchUri);
    if (canLaunch) {
      return launchUrl(callLaunchUri);
    } else {
      return false;
    }
  }

  Future<void> accessWeb() async {
    final String url = itemData.value!.item.url!;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

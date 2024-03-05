import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:idz/model/isar/isar_model.dart';
import 'package:idz/pages/home/models.dart';
import 'package:idz/pages/top/top_page_controller.dart';
import 'package:idz/providers/isar_provider.dart';
import 'package:idz/routes/app_pages.dart';
import 'package:idz/utils/environment_variables.dart';
import 'package:idz/utils/image_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ItemDetailPageController extends GetxController {
  final TopPageController topPageController = Get.find();

  Isar? isar;
  Rxn<ItemData> itemData = Rxn<ItemData>();
  Rxn<XFile?> selectedPicture = Rxn<XFile?>();
  Rxn<XFile?> previewPicture = Rxn<XFile?>();

  @override
  void onInit() {
    itemData.value = Get.arguments as ItemData;
    debugPrint('itemData.value!.imagePath: ${itemData.value!.imagePath}');
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

  Future<void> onTapImage(String uri) async {
    await Get.toNamed<void>(
      Routes.PHOTO_VIEW_PAGE,
      arguments: uri,
      // id: NavManager.getNavigationRouteId(Routes.HOME),
    );
    topPageController.isVisibleBottomNav.value = true;
  }

  /// 画像選択
  Future<void> selectPicture(BuildContext context) async {
    {
      selectedPicture.value = null;

      final XFile? selectedFile =
          await ImageSelector.showBottomSheetMenu(context);
      if (selectedFile == null) {
        return;
      }

      if (await selectedFile.length() > 10000000) {
        if (context.mounted) {
          await FlutterPlatformAlert.showAlert(
            windowTitle: 'エラー',
            text: '画像サイズが大き過ぎます。\n10MB以下の画像を選択してください。',
          );
        }
        return;
      }
      final List<int> headerBytes = await selectedFile.openRead(0, 12).first;
      final String? mimeType = lookupMimeType(
        p.basenameWithoutExtension(selectedFile.path),
        headerBytes: headerBytes,
      );
      if (EnvironmentVariables.allowedMimeType.contains(mimeType)) {
        selectedPicture.value = selectedFile;
        debugPrint(
            ' selectedPicture.value.path: ${selectedPicture.value!.path}');
      } else {
        if (context.mounted) {
          await FlutterPlatformAlert.showAlert(
            windowTitle: 'エラー',
            text: '選択されたファイルは画像ではありません。\n画像ファイルを選択してください。',
          );
        } else {
          await FlutterPlatformAlert.showAlert(
            windowTitle: 'Error',
            text:
                'The selected file is not an image. \nPlease select an image file.',
          );
        }
      }
    }
  }

  /// アプリ内フォルダに画像を保管
  /// isarにはファイル名で保管する(保存領域までのパスが変動するため)
  Future<String?> saveImageToFileSystem(
    XFile imageData,
  ) async {
    try {
      final String fileName =
          'IDz_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String storePath = (await getApplicationDocumentsDirectory()).path;
      final String imagePath = '$storePath/$fileName';
      await imageData.saveTo(imagePath);
      return fileName;
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Could not save image client Api: $e');
      }
      return null;
    }
  }
}

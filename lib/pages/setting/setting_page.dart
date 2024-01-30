import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idz/pages/setting/setting_page_controller.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingPageController>(
      init: SettingPageController(),
      builder: (SettingPageController controller) {
        return const Center(
          child: Text('Setting'),
        );
      },
    );
  }
}

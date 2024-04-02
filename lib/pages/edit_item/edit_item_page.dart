import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idz/pages/edit_item/edit_item_controller.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditItemPageController>(
      init: EditItemPageController(),
      builder: (EditItemPageController controller) {
        return const Center(
          child: Text('Setting'),
        );
      },
    );
  }
}

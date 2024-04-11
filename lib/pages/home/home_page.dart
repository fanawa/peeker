import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:idz/components/organisms/item_list_tile.dart';
import 'package:idz/pages/home/home_page_controller.dart';
import 'package:idz/pages/home/models.dart';
import 'package:idz/routes/app_pages.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _fbKey.currentState?.save();
    return GetBuilder<HomePageController>(
      init: HomePageController(),
      builder: (HomePageController controller) {
        return Scaffold(
          key: key,
          appBar: AppBar(
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                  onPressed: () async {
                    final dynamic result = await Get.toNamed<dynamic>(
                      Routes.CREATE_ITEM,
                      id: NavManager.getNavigationRouteId(Routes.HOME),
                    );
                    if (result is bool) {
                      debugPrint('result is bool; $result');
                      await controller.fetchItemData().then((_) async {
                        controller.update();
                      });
                    }
                  },
                ),
              ]),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchItemData();
                controller.update();
              },
              child: ListView(
                controller: controller.scrollController,
                shrinkWrap: true,
                children: <Widget>[
                  // const SizedBox(height: 30),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ReorderableGridView.builder(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.width >
                                MediaQuery.of(context).size.height
                            ? 130
                            : 100,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width >
                                MediaQuery.of(context).size.height
                            ? 4
                            : 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      onReorder: (int oldIndex, int newIndex) async {
                        // 追加ボタンのインデックスを確認
                        if (oldIndex == controller.items.length ||
                            newIndex == controller.items.length) {
                          // 追加ボタンが並び替えの対象となる場合は何もしない
                          return;
                        }
                        final ItemData item =
                            controller.items.removeAt(oldIndex);
                        controller.items.insert(newIndex, item);
                        for (int i = 0; i < controller.items.length; i++) {
                          controller.items[i].item.displayOrder = i + 1;
                        }
                        await controller.updateDisplayOrder(controller.items);
                        controller.update();
                      },
                      itemCount: controller.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        debugPrint(
                            'controller.items.length: ${controller.items.length}');
                        // 登録済みカード
                        final ItemData row = controller.items[index];
                        return ItemListTile(
                          key: Key(index.toString()),
                          itemData: row,
                          onTap: () async {
                            await Get.toNamed<void>(
                              Routes.ITEM_DETAIL,
                              arguments: row,
                              id: NavManager.getNavigationRouteId(Routes.HOME),
                            )!
                                .then(
                              (void value) async {
                                await controller.fetchItemData();
                                controller.update();
                              },
                            );
                            ;
                          },
                        );
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

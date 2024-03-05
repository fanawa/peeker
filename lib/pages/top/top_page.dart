import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idz/components/organisms/custom_bottom_navigation_bar.dart';
import 'package:idz/pages/root/root_page.dart';
import 'package:idz/pages/top/top_page_controller.dart';
import 'package:idz/routes/app_pages.dart';

class TopPage extends GetView<TopPageController> {
  TopPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        appBar: null,
        body: Stack(
          children: <Widget>[
            if (controller.check[0])
              _buildOffstageNavigator(
                controller.pages[0],
                controller.currentIndex.value != 0,
              ),
            if (controller.check[1])
              _buildOffstageNavigator(
                controller.pages[1],
                controller.currentIndex.value != 1,
              ),
          ],
        ),
        bottomNavigationBar: controller.isVisibleBottomNav.value
            ? CustomBottomNavigationBar(
                currentIndex:
                    NavManager.isBottomNavItem(controller.currentIndex.value)
                        ? controller.currentIndex.value
                        : controller.previousIndex.value,
              )
            : null,
      ),
    );
  }

  Widget _buildOffstageNavigator(String page, bool offstage) {
    return Offstage(
      offstage: offstage,
      child: TabRootPage(initialRoute: page),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peeker/pages/root/root_page.dart';
import 'package:peeker/pages/top/top_page_controller.dart';

class TopPage extends GetView<TopPageController> {
  TopPage({super.key});
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
            // if (controller.check[1])
            //   _buildOffstageNavigator(
            //     controller.pages[1],
            //     controller.currentIndex.value != 1,
            //   ),
          ],
        ),
        // bottomNavigationBar: controller.isVisibleBottomNav.value
        //     ? CustomBottomNavigationBar(
        //         currentIndex:
        //             NavManager.isBottomNavItem(controller.currentIndex.value)
        //                 ? controller.currentIndex.value
        //                 : controller.previousIndex.value,
        //       )
        //     : null,
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

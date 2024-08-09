import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peeker/pages/top/top_page_controller.dart';
import 'package:peeker/routes/app_pages.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopPageController>(
      global: true,
      init: TopPageController(),
      builder: (TopPageController controller) {
        return NavigationBar(
          key: key,
          selectedIndex: currentIndex,
          // currentIndex: currentIndex,
          onDestinationSelected: (int index) async {
            if (controller.currentIndex.value == index) {
              return;
            }
            if (controller.getHomeIndex() == index) {
              Get.until(
                (Route<dynamic> route) => route.settings.name == Routes.HOME,
                id: NavManager.getNavigationRouteId(Routes.HOME),
              );
            }

            controller.previousIndex.value = index;
            controller.changeIndex(index);
          },
          animationDuration: const Duration(milliseconds: 300),
          elevation: 6,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}

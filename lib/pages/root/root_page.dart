import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idz/routes/app_pages.dart';

class TabRootPage extends StatelessWidget {
  const TabRootPage({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      key: GlobalKey(),
      canPop: false,
      onPopInvoked: (bool didPop) {
        final GlobalKey<NavigatorState> routeKey = Get.key;
        if (routeKey.currentState!.canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: Navigator(
        key: Get.nestedKey(NavManager.getNavigationRouteId(initialRoute)),
        initialRoute: initialRoute,
        onGenerateRoute: (RouteSettings settings) =>
            PageRedirect(settings: settings).page<dynamic>(),
        onGenerateInitialRoutes:
            (NavigatorState navigator, String initialRoute) {
          final RouteSettings settings = RouteSettings(name: initialRoute);
          return <Route<dynamic>>[
            PageRedirect(settings: settings).page<dynamic>(),
          ];
        },
        observers: <GetObserver>[
          GetObserver((Routing? route) {}, Get.routing),
        ],
      ),
    );
  }
}

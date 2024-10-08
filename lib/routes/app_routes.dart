// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const String TOP = _Paths.TOP;
  static const String HOME = TOP + _Paths.HOME;
  // static const String SETTING = TOP + _Paths.SETTING;
  static const String ITEM_DETAIL = HOME + _Paths.ITEM_DETAIL;
  static const String CREATE_ITEM = HOME + _Paths.CREATE_ITEM;
  static const String EDIT_ITEM = ITEM_DETAIL + _Paths.EDIT_ITEM;
  static const String PHOTO_VIEW_PAGE = _Paths.PHOTO_VIEW_PAGE;
  static const String PRIVACY_POLICY = _Paths.PRIVACY_POLICY;
}

abstract class _Paths {
  static const String TOP = '/top';
  static const String HOME = '/home';
  // static const String SETTING = '/setting';
  static const String CREATE_ITEM = '/create';
  static const String EDIT_ITEM = '/edit';
  static const String ITEM_DETAIL = '/item_detail';
  static const String PHOTO_VIEW_PAGE = '/photoViewPage';
  static const String PRIVACY_POLICY = '/privacyPolicy';
}

class NavManager {
  static const List<String> ROUTES_BOTTOM_NAVIGATION = <String>[
    Routes.HOME,
    // Routes.SETTING,
  ];

  static const List<String> ALL_NAV_ROUTES = <String>[
    ...ROUTES_BOTTOM_NAVIGATION,
  ];

  static int getNavigationRouteId(String routePath) {
    return ALL_NAV_ROUTES.indexOf(routePath);
  }

  static bool isBottomNavItem(int index) {
    final String targetRoutes = ALL_NAV_ROUTES[index];
    return 0 < ROUTES_BOTTOM_NAVIGATION.indexOf(targetRoutes);
  }
}

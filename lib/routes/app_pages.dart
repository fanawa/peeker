import 'package:get/get.dart';
import 'package:idz/pages/home/home_page.dart';
import 'package:idz/pages/home/home_page_binding.dart';
import 'package:idz/pages/item_detail/item_detail_binding.dart';
import 'package:idz/pages/item_detail/item_detail_page.dart';
import 'package:idz/pages/setting/setting_page.dart';
import 'package:idz/pages/setting/setting_page_binding.dart';
import 'package:idz/pages/top/top_page.dart';
import 'package:idz/pages/top/top_page_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static final List<GetPage<dynamic>> list = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: _Paths.TOP,
      page: () => TopPage(),
      binding: TopPageBinding(),
      children: <GetPage<dynamic>>[
        GetPage<dynamic>(
          name: _Paths.HOME,
          page: () => HomePage(),
          binding: HomePageBinding(),
          children: <GetPage<dynamic>>[
            GetPage<dynamic>(
              name: _Paths.ITEM_DETAIL,
              page: () => const ItemDetailPage(),
              binding: ItemDetailPageBinding(),
            ),
          ],
        ),
        GetPage<dynamic>(
          name: _Paths.SETTING,
          page: () => const SettingPage(),
          binding: SettingPageBinding(),
        )
      ],
    )
  ];
}

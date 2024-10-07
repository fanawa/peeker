import 'package:get/get.dart';
import 'package:peeker/pages/create_item/create_item_binding.dart';
import 'package:peeker/pages/create_item/create_item_page.dart';
import 'package:peeker/pages/edit_item/edit_item_binding.dart';
import 'package:peeker/pages/edit_item/edit_item_page.dart';
import 'package:peeker/pages/home/home_page.dart';
import 'package:peeker/pages/home/home_page_binding.dart';
import 'package:peeker/pages/item_detail/item_detail_binding.dart';
import 'package:peeker/pages/item_detail/item_detail_page.dart';
import 'package:peeker/pages/photo_view/photo_view_page.dart';
import 'package:peeker/pages/photo_view/photo_view_page_binding.dart';
import 'package:peeker/pages/top/top_page.dart';
import 'package:peeker/pages/top/top_page_binding.dart';
import 'package:peeker/pages/web_view/web_view_page.dart';
import 'package:peeker/utils/environment_variables.dart';

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
              name: _Paths.CREATE_ITEM,
              page: () => CreateItemPage(),
              binding: CreateItemPageBinding(),
            ),
            GetPage<dynamic>(
                name: _Paths.ITEM_DETAIL,
                page: () => const ItemDetailPage(),
                binding: ItemDetailPageBinding(),
                children: <GetPage<dynamic>>[
                  GetPage<dynamic>(
                    name: _Paths.EDIT_ITEM,
                    page: () => EditItemPage(),
                    binding: EditItemPageBinding(),
                  )
                ]),
          ],
        ),

        // GetPage<dynamic>(
        //   name: _Paths.SETTING,
        //   page: () => const SettingPage(),
        //   binding: SettingPageBinding(),
        // )
      ],
    ),
    GetPage<dynamic>(
      name: _Paths.PHOTO_VIEW_PAGE,
      page: () => const PhotoViewPage(),
      binding: PhotoViewPageBinding(),
    ),
    GetPage<dynamic>(
      name: _Paths.PRIVACY_POLICY,
      page: () => const WebViewPage(
        url: EnvironmentVariables.PRIVACY_POLICY_URL,
      ),
    ),
  ];
}

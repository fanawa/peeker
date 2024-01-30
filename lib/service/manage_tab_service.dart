import 'package:get/get.dart';

/// タブ切り替えのサービス
/// currentIndexが現在のタブの状態とあう。
/// currentIndexを変更するとタブを切り替えることができる。
class ManageTabService extends GetxService {
  RxInt currentIndex = RxInt(0);
}

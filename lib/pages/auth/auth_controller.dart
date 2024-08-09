import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:peeker/utils/platform_information.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    authenticate();
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      // 初回起動かどうかを確認
      final bool isFirstRun = await _isFirstRun();

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        final String deviceId = await PlatformInfo.getDeviceId();
        if (isFirstRun) {
          // 初回起動時に deviceId を保存
          await storage.write(key: 'deviceId', value: deviceId);
        } else {
          // 2回目以降は deviceId の一致を確認
          final String? storedDeviceId = await storage.read(key: 'deviceId');
          if (storedDeviceId == deviceId) {
            isAuthenticated.value = true;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Could not authenticate Api: $e');
      }
    }
  }

  Future<bool> _isFirstRun() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final bool isFirstRun = sharedPreferences.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      await storage.deleteAll();
      await sharedPreferences.setBool('isFirstRun', false);
    }
    return isFirstRun;
  }
}

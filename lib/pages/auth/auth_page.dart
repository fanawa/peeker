import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peeker/pages/auth/auth_controller.dart';
import 'package:peeker/routes/app_pages.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  final AuthController faceAuthController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (faceAuthController.isAuthenticated.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.TOP);
          });
        }

        return Scaffold(
          body: Center(
            child: faceAuthController.isAuthenticated.value
                ? const Text('認証成功')
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

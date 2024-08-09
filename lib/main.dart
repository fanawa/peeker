import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peeker/bindings/initial_bindings.dart';
import 'package:peeker/routes/app_pages.dart';
import 'package:peeker/themes/light_theme.dart';

String _initialRoute = Routes.Auth;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
      theme: getLightTheme(context),
      initialBinding: InitialBindings(),
      initialRoute: _initialRoute,
      getPages: AppPages.list,
    );
  }
}

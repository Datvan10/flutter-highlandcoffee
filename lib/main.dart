import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:highlandcoffeeapp/routes/route.dart';
import 'package:highlandcoffeeapp/screens/app/welcome_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const WelcomePage(),
      getPages: getPages,
      theme: ThemeData(
        primaryColor: primaryColors,
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

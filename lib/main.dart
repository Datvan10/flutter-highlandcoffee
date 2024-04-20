import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:highlandcoffeeapp/routes/route.dart';
import 'package:highlandcoffeeapp/firebase_options.dart';
import 'package:highlandcoffeeapp/screens/app/welcome_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.ios
  );
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

// void main()  => runApp(
//       DevicePreview(
//         enabled: !kReleaseMode,
//         builder: (context) => const MyApp(), // Wrap your app
//       ),
//     );

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.ios
//   );
//   runApp(
//     const MyApp()
//     );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      home: WelcomePage(),
      getPages: getPages,
      theme: ThemeData(
        primaryColor: primaryColors,
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


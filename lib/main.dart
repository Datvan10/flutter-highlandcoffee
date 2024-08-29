import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:highlandcoffeeapp/routes/route.dart';
import 'package:highlandcoffeeapp/screens/app/receipt_page.dart';
import 'package:highlandcoffeeapp/screens/app/welcome_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.ios
//   );
//   runApp(
//     DevicePreview(
//       builder: (context) => MyApp(),
//     ),
//   );
// }

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(), // Wrap your app
      ),
    );

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
      home: const WelcomePage(),
      // home: ReceiptPage(
      //   receiptId: "12345",
      //   customerName: "Nguyễn Văn A",
      //   date: "2024-08-21",
      //   totalAmount: 100000.0,
      //   vat: 10000.0,
      //   discount: 5000.0,
      //   amountPaid: 95000.0,
      // ),
      getPages: getPages,
      theme: ThemeData(
        primaryColor: primaryColors,
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

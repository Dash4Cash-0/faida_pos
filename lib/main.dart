//import 'package:faida_pos/home_root.dart';
//import 'package:faida_pos/screens/app_initializer.dart';
import 'package:faida_pos/controllers/notification_controller.dart';
import 'package:faida_pos/controllers/product_controller.dart';
import 'package:faida_pos/controllers/reports_controller.dart';
import 'package:faida_pos/utils/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:window_size/window_size.dart' as window_size;
import 'package:faida_pos/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationController = NotificationController();
  await notificationController.load();
  final productController = ProductController
    (notificationController: notificationController);
  await productController.load();
  final reportsController = ReportsController();
  await reportsController.load();


  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    const width = 390.0;
    const height = 840.0;
    window_size.setWindowMinSize(const Size(width, height));
    window_size.setWindowMaxSize(const Size(width, height));
    window_size.setWindowFrame(
      const Rect.fromLTWH(100, 100, width, height),
    );
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: notificationController),
      ChangeNotifierProvider.value(value: productController),
      ChangeNotifierProvider.value(value: reportsController)
    ],
    child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp>{
  Locale _locale = const Locale("en");

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      },
      child: MaterialApp(
        locale: _locale,
        home: SplashScreen(),//HomeRoot(),//AppInitializer(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("en"),
          Locale("sw"),
        ],
      ),
    );
  }
}




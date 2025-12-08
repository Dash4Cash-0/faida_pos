import 'package:faida_pos/home_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:window_size/window_size.dart' as window_size;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      },
      child: const MaterialApp(
        home: HomeRoot(),
      ),
    );
  }
}



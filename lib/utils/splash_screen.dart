import 'package:faida_pos/home_root.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double _opacity = 0;

  @override void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100),() {
      setState(() {
        _opacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeRoot()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF05421d),
      body: Center(
        child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Image.asset('assets/images/splash_logo.png',
                width: 300)),
      ),
    );
  }
}

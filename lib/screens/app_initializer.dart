import 'package:faida_pos/security/pin_setup.dart';
import 'package:faida_pos/services/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../security/pin_lock.dart';
import 'language_selection.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  Widget? _nextScreen;

  @override
  void initState(){
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    String? language = await AppStorage.read('app_language');
    if(language == null){
      setState(() {
        _nextScreen = LanguageSelection();
        _isLoading = false;
      });
      return;
    }
    String? pinHash = await AppStorage.read('app_pin_hash');
    if(pinHash == null){
      setState(() {
        _nextScreen = PinSetup();
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _nextScreen = PinLock();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return _nextScreen!;
  }
}

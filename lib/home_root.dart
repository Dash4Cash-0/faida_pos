import 'package:faida_pos/controllers/checkout_controller.dart';
import 'package:faida_pos/controllers/product_controller.dart';
import 'package:faida_pos/screens/checkout.dart';
import 'package:faida_pos/screens/menu.dart';
import 'package:faida_pos/screens/notifications.dart';
import 'package:faida_pos/screens/reports.dart';
import 'package:faida_pos/screens/transactions.dart';
import 'package:faida_pos/services/voice_recording_service.dart';
import 'package:faida_pos/services/wake_up_service.dart';
import 'package:faida_pos/widgets/shared/navbar_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _currentIndex = 0;
  late final CheckoutController _controller;
  late VoiceRecordingService recording;
  final wakeUp = WakeUpService();

  bool _initialized = false;

  @override
  void initState(){
    super.initState();
    _controller = CheckoutController();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    if(!_initialized){
      final productController = context.read<ProductController>();
      recording = VoiceRecordingService(productController: productController);
      wakeUp.recording = recording;
      wakeUp.initialize().then((_) => wakeUp.startListening());
      _initialized = true;
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final screens = [
        Checkout(controller: _controller,
        recording: recording,
        wakeUp: wakeUp,),
        Transactions(),
        Reports(),
        Notifications(),
        Menu(),
      ];
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavbarBottom(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() => _currentIndex = index);
          }),
    );
  }
}

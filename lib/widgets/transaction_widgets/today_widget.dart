import 'package:flutter/material.dart';
class TodayWidget extends StatelessWidget {
  const TodayWidget({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            

          ],
        ),
      )),
    );
  }
}

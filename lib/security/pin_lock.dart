import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:faida_pos/home_root.dart';
import 'package:faida_pos/services/app_storage.dart';
import 'package:flutter/material.dart';

class PinLock extends StatefulWidget {
  const PinLock({super.key});

  @override
  State<PinLock> createState() => _PinLockState();
}

class _PinLockState extends State<PinLock> {
  String _pin = "";
  String _errorMessage = "";
  int _attemptCount = 0;

  void _onNumberPressed(String number) async {
    if(_pin.length < 4){
      setState(() {
        _pin += number;
      });

      if(_pin.length == 4){
        await _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _errorMessage = '';
      });
    }
  }

  void _onClear(){
    setState(() {
        if(_pin.isNotEmpty){
          _pin = '';
        }
    });
  }

  Future<void> _verifyPin() async {
    String? storedHash = await AppStorage.read('app_pin_hash');
    final bytes = utf8.encode(_pin);
    final hash = sha256.convert(bytes).toString();
    if(hash == storedHash) {
      if(!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeRoot())
      );
    } else {
      setState(() {
        _attemptCount++;
        _errorMessage = "Incorrect PIN";
        _pin = "";
      });
    }
    if (_attemptCount >= 5) {
      setState(() {
        _errorMessage = "Too many attempts. Try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                Text("Enter Pin",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 40),
                _buildPinDots(),
                if(_errorMessage.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Text(_errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14))
                ],
                SizedBox(height: 60),
                _buildNumPad()
              ],
            ))),
    );
  }
  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _pin.length ? Colors.blue : Colors.grey[300],
          ),
        );
      }),
    );
  }

  Widget _buildNumPad() {
    return Column(
      children: [
        _buildNumRow(['1', '2', '3']),
        SizedBox(height: 16),
        _buildNumRow(['4', '5', '6']),
        SizedBox(height: 16),
        _buildNumRow(['7', '8', '9']),
        SizedBox(height: 16),
        _buildNumRow(['C', '0', '⌫']),
      ],
    );
  }

  Widget _buildNumRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number.isEmpty) return SizedBox(width: 80);

        return InkWell(
          onTap: () {
            if (number == '⌫') {
              _onBackspace();
            }
            if (number == 'C'){
              _onClear();
            } else {
              _onNumberPressed(number);
            }
          },
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              number,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }

}

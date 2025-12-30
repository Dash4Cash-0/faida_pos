import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:faida_pos/home_root.dart';
import 'package:faida_pos/services/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinSetup extends StatefulWidget {
  const PinSetup({super.key});

  @override
  State<PinSetup> createState() => _PinSetupState();
}

class _PinSetupState extends State<PinSetup> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorMessage = '';

  void _onNumberPressed(String number){
    setState(() {
      if(!_isConfirming){
        if(_pin.length < 4) {
          _pin += number;
          if(_pin.length == 4) {
            _isConfirming = true;
            _errorMessage = '';
          }
        }
      } else {
        if(_confirmPin.length < 4){
          _confirmPin += number;
          if(_confirmPin.length == 4){
            _validateAndSavePin();
          }
        }
      }
    }
    );
  }

  void _onClear(){
    setState(() {
      if(!_isConfirming){
        if(_pin.isNotEmpty){
          _pin = '';
        }
      }
    });
  }

  void _onBackSpace() {
    setState(() {
      if(!_isConfirming){
        if(_pin.isNotEmpty){
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }else{
        if(_confirmPin.isNotEmpty){
          _confirmPin = _confirmPin.substring(0,_confirmPin.length - 1);
        }
      }
      _errorMessage = "";
    });
  }

  Future<void> _validateAndSavePin() async {
    if(_pin != _confirmPin){
      setState(() {
        _errorMessage = "PINs do not match";
        _confirmPin = "";
      });
      return;
    }
    final bytes = utf8.encode(_pin);
    final hash = sha256.convert(bytes).toString();
    await AppStorage.write("app_pin_hash", hash);
    if(!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeRoot())
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:
          Padding(
              padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  _isConfirming ? "Confirm PIN" : "Create PIN",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  _isConfirming
                      ? "Enter your PIN again"
                      : "Enter a 4-digit PIN",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 40),
                _buildPinDots(),
                if(_errorMessage.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Text(_errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14))
                ],
                SizedBox(height: 60),
                _buildNumPad(),
              ],
            ))),
    );
  }

  Widget _buildPinDots() {
    int pinLength = _isConfirming ? _confirmPin.length : _pin.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pinLength ? Colors.blue : Colors.grey[300]
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
        SizedBox(height: 16)
  ],
      );
}

Widget _buildNumRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((num) {
        if(num.isEmpty) return SizedBox(width: 80);

        return InkWell(
          onTap: () {
            if(num == '⌫'){
              _onBackSpace();
            }
            if(num == 'C'){
              _onClear();
            } else {
              _onNumberPressed(num);
            }
          },
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!)
            ),
            child: Text(num,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

        );
      }
      ).toList(),
    );
}
}

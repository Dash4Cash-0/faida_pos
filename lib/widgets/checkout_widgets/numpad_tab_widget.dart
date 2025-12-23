import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'numpad_display_widget.dart';
import 'numpad_widget.dart';

class NumpadTabWidget extends StatelessWidget {

  final Function(String) onNumPressed;
  final VoidCallback onClear;
  final VoidCallback onPlusPressed;
  final String value;
  final String partValues;
  final double storedValue;

  const NumpadTabWidget({
    super.key,
    required this.onNumPressed,
    required this.onClear,
    required this.onPlusPressed,
    required this.value,
    required this.partValues,
    required this.storedValue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        NumpadDisplayWidget(value: value),
        Text(partValues),
        Text("${l10n.total}: $storedValue TZS"),
        Expanded(
            child: Numpad(
                onNumberPressed: onNumPressed,
                onClearPressed: onClear,
                onPlusPressed: onPlusPressed)),
      ],
    );
  }
}

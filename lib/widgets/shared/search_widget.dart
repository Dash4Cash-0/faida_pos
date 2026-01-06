import 'package:flutter/material.dart';
class SearchWidget extends StatelessWidget {

  final ValueChanged<String> onSearch;

  const SearchWidget({super.key,
    required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return
      TextField(
      onChanged: onSearch,
      decoration: InputDecoration(
        hintText: "Search item",
        prefixIcon: Icon(Icons.search)
      ),
    );
  }
}

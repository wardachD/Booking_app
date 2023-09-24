import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _isSearchVisible = true;

  void _navigateToDiscoverPage() {
    Get.find<BottomAppBarIndexController>().setBottomAppBarIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide:
                const BorderSide(color: Colors.grey), // Change the border color here
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
                color: Colors.blue), // Change the focused border color here
          ),
          labelText: 'Search for a service...',
          prefixIcon: _isSearchVisible ? const Icon(Icons.search) : null,
          suffixIcon: !_isSearchVisible ? const Icon(Icons.clear) : null,
        ),
        onTap: () {
          _navigateToDiscoverPage();
        },
        onChanged: (value) {
          setState(() {
            _isSearchVisible = value.isEmpty;
          });
        },
      ),
    );
  }
}

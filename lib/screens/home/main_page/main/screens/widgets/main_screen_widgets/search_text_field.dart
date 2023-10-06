import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<BottomAppBarIndexController>().setBottomAppBarIndex(1);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16.0), // You can adjust the padding as needed
        child: const Row(
          children: [
            Icon(Icons.search), // Icon for search
            SizedBox(width: 16), // Adjust the space between icon and text
            Text(
              'Search for a service...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:findovio/consts.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String response;

  const BookingConfirmationScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      // Navigate to the main screen after 4 seconds
      Get.offAllNamed(Routes.HOME);
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/gifs/confirmed.gif'), // Replace with your GIF path
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Text(
                'Twoja wizyta została umówiona!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

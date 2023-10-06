import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleBarWithBackButton extends StatelessWidget {
  final String title;

  const TitleBarWithBackButton({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        const Spacer(flex: 1),
        Column(
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.anybody(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

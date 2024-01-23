import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final String socialMediaType;

  const SocialIcon({super.key, required this.socialMediaType});

  String getIconPath(String socialMediaType) {
    switch (socialMediaType) {
      case 'facebook':
        return 'assets/icons/facebook.png';
      case 'google':
        return 'assets/icons/google.png';
      case 'apple':
        return 'assets/icons/apple-logo.png';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Image.asset(
          getIconPath(socialMediaType),
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}

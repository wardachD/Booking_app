import 'package:findovio/screens/intro/widgets/social_icon.dart';
import 'package:flutter/material.dart';

class SocialCaseChoose extends StatelessWidget {
  const SocialCaseChoose({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SocialIcon(
          socialMediaType: 'google',
        ),
        SocialIcon(
          socialMediaType: 'facebook',
        ),
        SocialIcon(
          socialMediaType: 'apple',
        ),
      ],
    );
  }
}

import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TitleBarWithBackButton extends StatelessWidget {
  final String title;
  VoidCallback? callbackToChangeIsSearchActive;

  TitleBarWithBackButton({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<DiscoverPageFilterProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 19,
          ),
          onPressed: () {
            Get.back();
            userDataProvider.setAllToEmptyWithoutNotification();
            Provider.of<AnimatedTopBarProvider>(context, listen: false)
                .setDefault();
          },
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

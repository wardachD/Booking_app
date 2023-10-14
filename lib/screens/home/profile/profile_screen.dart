import 'package:findovio/widgets/title_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: const Column(
            children: [
              SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleBar(text: "twój profil"),
                  Icon(Icons.face),
                ],
              ),
            ],
          )),
    ));
  }
}

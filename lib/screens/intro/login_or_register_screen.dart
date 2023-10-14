import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_pages.dart';

class LoginOrRegisterScreen extends StatelessWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Book services you love hassle-free',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.anybody(
                        fontWeight: FontWeight.bold, fontSize: 35.0)),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
                  child: Text(
                      'find a new stylist, book last-minute nails, or treat yourself to a relaxing massage',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.anybody(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 88, 88, 88),
                      )),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 130,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => {
                      Get.toNamed(Routes.INTRO_LOGIN),
                    },
                    child: const Text('Log in'),
                  ),
                ),
                SizedBox(
                  width: 130,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () => {
                            Get.toNamed(Routes.INTRO_REGISTER),
                          },
                      child: const Text('Register')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

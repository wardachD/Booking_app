import 'package:flutter/material.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/splash_login.png'),
                Text('Discover local professionals',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.anybody(
                        fontWeight: FontWeight.bold, fontSize: 35.0)),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 5, 50, 25),
                  child: Text(
                      'Browse for beauty, wellness and all sort of services',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.anybody(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 61, 61, 61),
                      )),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () => {
                    Get.offNamed(Routes.INTRO_SIGN),
                  },
                  child: const Text('Rozpocznij'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

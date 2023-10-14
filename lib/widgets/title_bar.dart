import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleBar extends StatelessWidget {
  final String text;

  const TitleBar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      // Jeśli text jest pusty, zwróć pusty kontener
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.anybody(
          color: const Color.fromARGB(255, 31, 31, 31),
          fontWeight: FontWeight.w900,
          fontSize: 22,
          height: 1,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class TitleBarWithoutHeight extends StatelessWidget {
  final String text;

  const TitleBarWithoutHeight({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      // Jeśli text jest pusty, zwróć pusty kontener
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.anybody(
          color: const Color.fromARGB(255, 31, 31, 31),
          fontWeight: FontWeight.w900,
          fontSize: 22,
          height: 1,
          letterSpacing: 0.21,
        ),
      ),
    );
  }
}

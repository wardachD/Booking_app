import 'package:flutter/material.dart';

class CustomHorizontalBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 6,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 194, 194, 194),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

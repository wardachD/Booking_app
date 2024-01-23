import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';

class BookingCardPlaceholder extends StatelessWidget {
  const BookingCardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var animateGradient = AnimateGradient(
        duration: const Duration(milliseconds: 1200),
        primaryBegin: Alignment.centerRight,
        primaryEnd: Alignment.centerRight,
        secondaryBegin: Alignment.centerLeft,
        secondaryEnd: Alignment.centerLeft,
        primaryColors: [
          Color.fromARGB(202, 255, 255, 255),
          Color.fromARGB(160, 255, 172, 64)
        ],
        secondaryColors: [
          Color.fromARGB(113, 255, 172, 64),
          Color.fromARGB(101, 255, 255, 255)
        ]);
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 8),
              child: Text(
                'Rezerwacje',
                textAlign: TextAlign.start,
                style: TextStyle(
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color.fromARGB(255, 22, 22, 22)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,
              height: MediaQuery.of(context).size.height * 0.13,
              margin: const EdgeInsets.only(right: 16.0, bottom: 20, top: 5),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: AppColors.lightColorTextField,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.14,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: animateGradient)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 130,
                            child: animateGradient,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Align contents to the left
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 80,
                                    child: animateGradient,
                                  ),
                                  const SizedBox(height: 2),
                                  SizedBox(
                                    height: 20,
                                    width: 90,
                                    child: animateGradient,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: 30,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primaryLightColorText,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

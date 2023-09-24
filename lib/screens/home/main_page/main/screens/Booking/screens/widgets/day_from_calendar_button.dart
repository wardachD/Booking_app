import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';

class dayFromCalendar extends StatelessWidget {
  const dayFromCalendar({
    super.key,
    required this.itemWidth,
    required this.isCurrentDateSelected,
    required this.hasTimeSlots,
    required this.day,
    required this.weekday,
  });

  final double itemWidth;
  final bool isCurrentDateSelected;
  final bool hasTimeSlots;
  final String day;
  final String weekday;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: itemWidth,
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isCurrentDateSelected
              ? AppColors.accentColor // Border color when selected
              : hasTimeSlots
                  ? AppColors
                      .accentColor // Transparent border when has time slots
                  : const Color.fromARGB(
                      255, 243, 243, 243), // Border color when no time slots
        ),
        color: isCurrentDateSelected
            ? AppColors.accentColor
            : hasTimeSlots
                ? const Color.fromARGB(0, 255, 255, 255)
                : const Color.fromARGB(255, 243, 243,
                    243), // <-- Zmieniamy tło w zależności od wyboru
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isCurrentDateSelected
                  ? Colors.white // Font color when selected
                  : hasTimeSlots
                      ? Colors.black
                      : const Color.fromARGB(255, 204, 204, 204),
            ),
          ),
          Text(
            weekday,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: isCurrentDateSelected
                  ? Colors.white // Font color when selected
                  : hasTimeSlots
                      ? Colors.black
                      : const Color.fromARGB(255, 204, 204, 204),
            ),
          ),
        ],
      ),
    );
  }
}

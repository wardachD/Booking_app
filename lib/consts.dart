import 'package:flutter/material.dart';

abstract class Consts {
  static const dbApi = 'http://185.180.204.182:8000/api';
  static const dbApiGetAll =
      'http://185.180.204.182:8000/api/salons/?format=json';
  static const dbApiGetOne = 'http://185.180.204.182:8000/api/salons/';
  static const dbApiSearch = 'http://185.180.204.182:8000/api/search/?';
  static const dbApiGetReviews = 'http://185.180.204.182:8000/api/salons/';
  static const dbApiPostBooking =
      'http://185.180.204.182:8000/api/appointments/';
  static const dbApiGetUserBookings =
      'http://185.180.204.182:8000/api/user-appointments/?format=json&user_id=';
  static const dbApiGetSalonService =
      'http://185.180.204.182:8000/api/services/';
}

abstract class ConstsWidgets {
  static const gapW4 = SizedBox(width: 4.0);
  static const gapW8 = SizedBox(width: 8.0);
  static const gapW12 = SizedBox(width: 12.0);
  static const gapW16 = SizedBox(width: 16.0);
  static const gapW20 = SizedBox(width: 20.0);

  static const gapH4 = SizedBox(height: 4.0);
  static const gapH8 = SizedBox(height: 8.0);
  static const gapH12 = SizedBox(height: 12.0);
  static const gapH16 = SizedBox(height: 16.0);
  static const gapH20 = SizedBox(height: 20.0);
}

abstract class AppointmentStatus {
  static const String finished = 'F';
  static const String cancelled = 'X';
  static const String confirmed = 'C';
  static const String pending = 'P';
}

abstract class AppColors {
  static const Color backgroundColor = Colors.white;
  static const Color accentColor = Color.fromARGB(255, 241, 142, 49);
  static const Color primaryColorText = Color.fromARGB(255, 8, 8, 8);
  static const Color primaryLightColorText = Color.fromARGB(255, 56, 56, 56);
}

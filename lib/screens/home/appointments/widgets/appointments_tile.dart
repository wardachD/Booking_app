import 'package:findovio/consts.dart';
import 'package:findovio/models/appointments_tile_text_colors.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/main_page/main/screens/Booking/screens/booking_schedule.dart';
import 'package:findovio/utilities/authentication/months_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../utils/date_convert.dart';

class AppointmentTile extends StatelessWidget {
  final UserAppointment userAppointment;

  const AppointmentTile({
    Key? key,
    required this.userAppointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String isMoreServices = (userAppointment.services.length > 1)
        ? '  + ${userAppointment.services.length - 1} more'
        : '';
    DateTime dateToDateTime = DateTime.parse(userAppointment.timeslots[0].date);
    String monthFromObject =
        MonthsUtils.getMonthName(dateToDateTime.month).substring(0, 3);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.12,
                height: MediaQuery.sizeOf(context).width * 0.12,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(width: 10.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userAppointment.services[0].description}$isMoreServices',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow
                          .ellipsis, // Truncate long texts with ellipsis
                    ),
                    ConstsWidgets.gapH4,
                    Text(
                      userAppointment.salonName,
                      style: GoogleFonts.anybody(
                        color: AppColors.primaryLightColorText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ConstsWidgets.gapH20,
          Container(
            height: MediaQuery.sizeOf(context).height * 0.06,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 243, 243),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.calendar_month_rounded,
                    color: AppColors.primaryLightColorText),
                const SizedBox(width: 10.0),
                Text(
                    '${dateToDateTime.day.toString()} $monthFromObject, ${timeWithoutSeconds(userAppointment.timeslots[0])} - ${timeWithoutSeconds(userAppointment.timeslots[userAppointment.timeslots.length - 1])}'),
                Row(
                  children: [
                    userAppointment.status == AppointmentStatus.confirmed ||
                            userAppointment.status == AppointmentStatus.finished
                        ? const Icon(Icons.check_circle,
                            size: 18, color: Color.fromARGB(255, 102, 156, 80))
                        : (userAppointment.status == "P"
                            ? const Icon(Icons.access_time,
                                size: 18,
                                color: Color.fromRGBO(241, 209, 94, 1))
                            : const Icon(Icons.cancel,
                                size: 18, color: Colors.red)),
                    const SizedBox(
                        width: 5.0), // Add some spacing between icon and text
                    Text(
                      getStatusText(userAppointment.status),
                      style: TextStyle(
                        color: getStatusColor(userAppointment.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConstsWidgets.gapH20,
          Visibility(
            visible: [AppointmentStatus.finished, AppointmentStatus.cancelled]
                .contains(userAppointment.status),
            child: SizedBox(
              width: double.infinity, // Set the button width to double.infinity
              child: ElevatedButton(
                onPressed: () async {
                  // variables
                  int totalDuration = 0;
                  num totalPrice = 0;
                  int timeslotsNeeded = 0;

                  // salon
                  var salon = await fetchSalons(http.Client());
                  salon = salon
                      .where((salon) => salon.id == userAppointment.salon)
                      .toList();
                  SalonModel selectedSalon = salon
                      .firstWhere((salon) => salon.id == userAppointment.salon);

                  // services
                  userAppointment.services;

                  // schedule
                  Future<List<SalonSchedule>> schedule =
                      fetchSalonSchedules(http.Client(), userAppointment.salon);

                  // working hours
                  List<SalonWorkingHours> workingHoursList =
                      await fetchSalonWorkingHours(
                          http.Client(), userAppointment.salon);

                  if (workingHoursList.isNotEmpty) {
                    final timeslotLength = workingHoursList[0]
                        .timeSlotLength; // Assuming the first element
                    totalDuration = 0;
                    totalPrice = 0;
                    timeslotsNeeded = 0;

                    // Calculate total duration and price
                    for (var service in userAppointment.services) {
                      totalDuration += service.durationMinutes;
                      totalPrice += num.parse(service.price);
                    }

                    // Calculate timeslotsNeeded
                    timeslotsNeeded = (totalDuration + timeslotLength - 1) ~/
                        timeslotLength; // Rounded up division
                  }

                  Future<List<SalonWorkingHours>> workingHoursFuture =
                      Future<List<SalonWorkingHours>>.value(workingHoursList);

                  Get.to(() => BookingSchedule(
                      salon: selectedSalon,
                      services: userAppointment.services,
                      schedule: schedule,
                      workingHours: workingHoursFuture,
                      duration: totalDuration,
                      price: totalPrice,
                      amountOfTimeslots: timeslotsNeeded));
                  // Now, you have totalDuration, totalPrice, and timeslotsNeeded calculated.
                  // You can use these values as needed.
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.backgroundColor),
                  overlayColor: MaterialStateProperty.all<Color>(Colors
                      .white), // Set button background color to transparent
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Set border color and width
                    ),
                  ),
                ),
                child: const Text("Book Again"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

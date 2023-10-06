import 'package:findovio/consts.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/screens/home/appointments/screens/selected_appointment.dart';
import 'package:findovio/utilities/authentication/months_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingCard extends StatelessWidget {
  final UserAppointment appointment;

  const BookingCard({Key? key, required this.appointment}) : super(key: key);

  void _goToAppointmentTabSelectedAppointmentPage() {
    Get.find<BottomAppBarIndexController>().setBottomAppBarIndex(2);
  }

  @override
  Widget build(BuildContext context) {
    DateTime jsonToDate = DateTime.parse(appointment.dateOfBooking);
    String bookingHour =
        '${appointment.timeslots[0].timeFrom.split(':')[0]}:${appointment.timeslots[0].timeFrom.split(':')[1]} ';
    int amountOfServicesToPrint = appointment.services.length - 1;
    String isMoreServices =
        (amountOfServicesToPrint > 1) ? '+ $amountOfServicesToPrint more' : '';

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () async {
          _goToAppointmentTabSelectedAppointmentPage();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectedAppointmentScreen(
                appointmentData: appointment,
              ),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.88,
          height: MediaQuery.of(context).size.height * 0.13,
          margin: const EdgeInsets.only(right: 8.0, bottom: 20, top: 5),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.14,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 143, 255, 149),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        MonthsUtils.getMonthName(jsonToDate.month)
                            .substring(0, 3)
                            .toUpperCase(),
                        style: GoogleFonts.anybody(
                            color: AppColors.primaryColorText,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${jsonToDate.day}',
                        style: GoogleFonts.anybody(
                            color: AppColors.primaryColorText,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${jsonToDate.year % 2000}',
                        style: GoogleFonts.anybody(
                            color: AppColors.primaryColorText,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
                      Text(
                        '${appointment.services[0].title} $isMoreServices',
                        style: GoogleFonts.anybody(
                            color: AppColors.primaryColorText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align contents to the left
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place,
                                    size: 15,
                                    color: AppColors.primaryLightColorText,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    appointment.salonName,
                                    style: GoogleFonts.anybody(
                                        color: const Color.fromARGB(
                                            255, 122, 122, 122),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.watch_later,
                                    size: 13,
                                    color: AppColors.primaryLightColorText,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    bookingHour,
                                    style: GoogleFonts.anybody(
                                        color: AppColors.primaryLightColorText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
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
    );
  }
}

import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/booking_card_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'upcoming_appointments_list.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';

class UpcomingAppointments extends StatelessWidget {
  final String userId;

  const UpcomingAppointments({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<FirebasePyUserProvider>(
            builder: (context, provider, child) {
              provider.fetchDataWithoutUpdate();
              final appointments = provider.appointments;
              bool isUpcoming = false;

              if (appointments == null) {
                // Data is not available yet, display a loading indicator
                return const Center(child: BookingCardPlaceholder());
              } else if (appointments.isEmpty) {
                // No upcoming appointments
                return const SizedBox();
              } else {
                for (var element in appointments) {
                  if (element.status == 'C' || element.status == 'P') {
                    DateTime bookingDateToDateTime =
                        DateTime.parse(element.dateOfBooking);
                    isUpcoming = DateTime.now().isBefore(bookingDateToDateTime);
                    break;
                  }
                }
                if (isUpcoming) {
                  return UpcomingAppointmentsList(appointments: appointments);
                } else {
                  return const SizedBox();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:findovio/models/user_appointment.dart';
import 'package:flutter/material.dart';

import 'booking_card.dart';

class UpcomingAppointmentsList extends StatelessWidget {
  final List<UserAppointment> appointments;

  const UpcomingAppointmentsList({Key? key, required this.appointments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          children: appointments
              .map((appointment) => BookingCard(appointment: appointment))
              .toList(),
        ),
      ),
    );
  }
}

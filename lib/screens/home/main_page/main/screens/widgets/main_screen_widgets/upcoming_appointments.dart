import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'upcoming_appointments_list.dart';

class UpcomingAppointments extends StatefulWidget {
  final String userId;

  const UpcomingAppointments({super.key, required this.userId});

  @override
  State<UpcomingAppointments> createState() => _UpcomingAppointmentsState();
}

class _UpcomingAppointmentsState extends State<UpcomingAppointments> {
  late Future<List<UserAppointment>> _futureAppointment;

  @override
  void initState() {
    super.initState();
    _futureAppointment = fetchAppointments(http.Client(), widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
      child: Column(
        children: [
          FutureBuilder<List<UserAppointment>>(
            future: _futureAppointment,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final appointments = snapshot.data!;

                if (appointments.isEmpty) {
                  return const SizedBox.shrink();
                }

                return UpcomingAppointmentsList(appointments: appointments);
              } else {
                // Handle the case where the future is completed but returns null or empty data
                return const SizedBox.shrink(); // Return an empty widget
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/screens/home/appointments/appointments_screen.dart';
import 'package:findovio/screens/home/appointments/widgets/appointments_tile.dart';

class UpcomingAppointmentsList extends StatefulWidget {
  final AppointmentsScreen widget;
  final String statusToShow;
  late Future<List<UserAppointment>>?
      appointmentDataFromRequest; // Add this line

  UpcomingAppointmentsList({
    Key? key,
    required this.widget,
    required this.appointmentDataFromRequest,
    required this.statusToShow, // Add this parameter
  }) : super(key: key);

  @override
  _UpcomingAppointmentsListState createState() =>
      _UpcomingAppointmentsListState();
}

class _UpcomingAppointmentsListState extends State<UpcomingAppointmentsList> {
  Future<List<UserAppointment>>? newAppointmentDataFromRequest;
  late List<UserAppointment> filteredAppointments;
  late Future<bool>
      areListsEqual; // Add a flag to track if data has been fetched

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserAppointment>>(
      future: widget.appointmentDataFromRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Filter appointments with status 'canceled'
          if (widget.statusToShow == AppointmentStatus.confirmed) {
            filteredAppointments = snapshot.data!
                .where((appointment) =>
                    appointment.status == AppointmentStatus.confirmed ||
                    appointment.status == AppointmentStatus.pending)
                .toList();
          } else {
            filteredAppointments = snapshot.data!
                .where(
                    (appointment) => appointment.status == widget.statusToShow)
                .toList();
          }

          if (filteredAppointments.isEmpty) {
            return const Text('No appointments available.');
          }

          return ListView.builder(
            // I want to see the nearest schedule first
            itemCount: filteredAppointments.length,
            itemBuilder: (context, index) {
              print('done 2');
              final appointment = filteredAppointments[index];
              return AppointmentTile(userAppointment: appointment);
            },
          );
        } else {
          return const Text('No appointments available.');
        }
      },
    );
  }
}

import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/appointments/widgets/appointment_tile_placeholder.dart';
import 'package:findovio/screens/home/appointments/widgets/hidable_advertisements.dart';
import 'package:flutter/material.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/screens/home/appointments/appointments_screen.dart';
import 'package:findovio/screens/home/appointments/widgets/appointments_tile.dart';

class UpcomingAppointmentsList extends StatefulWidget {
  final AppointmentsScreen widget;
  final String statusToShow;
  final Future<List<UserAppointment>>? appointmentDataFromRequest;
  final VoidCallback callback;

  const UpcomingAppointmentsList({
    Key? key,
    required this.widget,
    required this.appointmentDataFromRequest,
    required this.statusToShow,
    required this.callback,
  }) : super(key: key);

  @override
  State<UpcomingAppointmentsList> createState() =>
      _UpcomingAppointmentsListState();
}

class _UpcomingAppointmentsListState extends State<UpcomingAppointmentsList> {
  late List<UserAppointment> filteredAppointments;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserAppointment>>(
      future: widget.appointmentDataFromRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            children: [
              SizedBox(
                height: 277, // Adjust the height as needed
                child: AppointmentTilePlaceholder(),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Błąd: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Filter appointments with status 'canceled'
          if (widget.statusToShow == AppointmentStatus.confirmed ||
              widget.statusToShow == AppointmentStatus.confirmed) {
            filteredAppointments = snapshot.data!
                .where((appointment) =>
                    appointment.status == AppointmentStatus.confirmed ||
                    appointment.status == AppointmentStatus.pending)
                .toList();
          } else if (widget.statusToShow == AppointmentStatus.finished) {
            filteredAppointments = snapshot.data!
                .where((appointment) =>
                    appointment.status == AppointmentStatus.finished)
                .toList();
          } else {
            filteredAppointments = snapshot.data!
                .where(
                    (appointment) => appointment.status == widget.statusToShow)
                .toList();
          }

          if (filteredAppointments.isEmpty) {
            return Padding(
              padding: EdgeInsets.zero,
              child: HidableColumnWidget(),
            );
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: ListView.builder(
              // I want to see the nearest schedule first
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return AppointmentTile(
                  userAppointment: appointment,
                  callback: widget.callback,
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.zero,
            child: HidableColumnWidget(),
          );
        }
      },
    );
  }
}

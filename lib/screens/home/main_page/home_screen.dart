import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/screens/home/appointments/appointments_screen.dart';
import 'package:findovio/screens/home/discover/discover_page.dart';
import 'package:findovio/screens/home/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../controllers/bottom_app_bar_index_controller.dart';
import '../../../providers/api_service.dart';
import 'main/main_screen.dart';
import 'widgets/bottom_app_bar.dart';

class HomeScreen extends GetView<BottomAppBarIndexController> {
  HomeScreen({super.key});
  bool isAppointmentUpdateNeeded = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataProvider>(context).user;
    late Future<List<UserAppointment>>? appointmentData =
        fetchAppointments(http.Client(), user!.uid);
    return Scaffold(
      bottomNavigationBar: const CustomBottomAppBar(),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Obx(() {
            return _getSelectedPage(
                controller.activeIndex.value, appointmentData);
          }),
        ),
      ),
    );
  }

  Widget _getSelectedPage(
      int index, Future<List<UserAppointment>>? appointmentData) {
    switch (index) {
      case 0:
        isAppointmentUpdateNeeded = true;
        return const MainScreen();
      case 1:
        isAppointmentUpdateNeeded = true;
        return const DiscoverScreen();
      case 2:
        if (appointmentData != null) {
          return AppointmentsScreen(
            appointmentDataFromRequest: appointmentData,
          );
        } else {
          return AppointmentsScreen();
        }
      case 3:
        isAppointmentUpdateNeeded = true;
        return const ProfileScreen();
      default:
        isAppointmentUpdateNeeded = false;
        return const MainScreen();
    }
  }
}

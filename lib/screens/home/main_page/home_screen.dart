import 'package:findovio/screens/home/appointments/appointments_screen.dart';
import 'package:findovio/screens/home/discover/discover_page.dart';
import 'package:findovio/screens/home/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/bottom_app_bar_index_controller.dart';
import 'main/main_screen.dart';
import 'widgets/bottom_app_bar.dart';

class HomeScreen extends GetView<BottomAppBarIndexController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomAppBar(),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Obx(() => _getSelectedPage(controller.activeIndex.value)),
        ),
      ),
    );
  }

  static Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const MainScreen();
      case 1:
        return const DiscoverScreen();
      case 2:
        return const AppointmentsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const MainScreen();
    }
  }
}

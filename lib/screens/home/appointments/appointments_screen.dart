import 'package:buttons_tabbar2/buttons_tabbar.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'widgets/upcoming_appointments_list.dart';

class AppointmentsScreen extends StatefulWidget {
  final bool? isBridgeNavigation; // Optional boolean variable

  AppointmentsScreen({Key? key, this.isBridgeNavigation}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Future<List<UserAppointment>> fetchData() async {
    final user = Provider.of<UserDataProvider>(context).user;
    return fetchAppointments(http.Client(), user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<UserAppointment>>? appointmentDataFromRequest = fetchData();
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Column(
              children: [
                const TitleBar(text: 'My\nappointments'),
                ButtonsTabBar(
                  controller: _tabController,
                  radius: 16.0,
                  height: 45,
                  backgroundColorGlobal:
                      const Color.fromARGB(255, 231, 230, 230),
                  backgroundColor: const Color.fromARGB(255, 253, 162, 155),
                  unselectedBackgroundColor:
                      const Color.fromARGB(255, 231, 230, 230),
                  unselectedLabelStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                    Tab(text: "Cancelled"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      UpcomingAppointmentsList(
                        widget: widget,
                        appointmentDataFromRequest: appointmentDataFromRequest,
                        statusToShow: AppointmentStatus.confirmed,
                      ),
                      UpcomingAppointmentsList(
                        widget: widget,
                        appointmentDataFromRequest: appointmentDataFromRequest,
                        statusToShow: AppointmentStatus.finished,
                      ),
                      UpcomingAppointmentsList(
                        widget: widget,
                        appointmentDataFromRequest: appointmentDataFromRequest,
                        statusToShow: AppointmentStatus.cancelled,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

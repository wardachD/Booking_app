import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/screens/home/main_page/main/screens/Booking/screens/booking_schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'widgets/title_bar_with_back_button.dart';

class BookingScreen extends StatefulWidget {
  final SalonModel salon;
  final List<Services> services;
  final Future<List<SalonSchedule>> schedule;
  final Future<List<SalonWorkingHours>> workingHours;

  const BookingScreen(
      {super.key,
      required this.salon,
      required this.services,
      required this.schedule,
      required this.workingHours});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int totalDuration = 0;
  num totalPrice = 0;
  int timeslotsNeeded = 0;

  @override
  void initState() {
    computeDurationAndPrice();
    super.initState();
  }

  @override
  void dispose() {
    totalDuration = 0;
    timeslotsNeeded = 0;
    super.dispose();
  }

  void computeDurationAndPrice() {
    totalDuration = 0;
    totalPrice = 0;
    for (var service in widget.services) {
      totalDuration += service.durationMinutes;
      totalPrice += num.parse(service.price);
    }
    // Fetch the working hours to determine the timeslot length
    widget.workingHours.then((List<SalonWorkingHours> workingHoursList) {
      if (workingHoursList.isNotEmpty) {
        final timeslotLength = workingHoursList[1].timeSlotLength;
        setState(() {
          timeslotsNeeded = (totalDuration + timeslotLength - 1) ~/
              timeslotLength; // Rounded up division
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const TitleBarWithBackButton(
                  title: 'Confirm Services',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.services.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                            title: Text(widget.services[index].title),
                            subtitle: Text(widget.services[index].description),
                            trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: Icon(MdiIcons.delete),
                                    onTap: () {
                                      setState(() {
                                        widget.services.removeAt(index);
                                        computeDurationAndPrice();
                                      });
                                    },
                                  ),
                                  Text('${widget.services[index].price} zł')
                                ])),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.accentColor,
        child: TextButton(
          onPressed: () {
            Get.to(() => BookingSchedule(
                salon: widget.salon,
                services: widget.services,
                schedule: widget.schedule,
                workingHours: widget.workingHours,
                duration: totalDuration,
                price: totalPrice,
                amountOfTimeslots: timeslotsNeeded));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Rezerwuj za $totalPrice zł',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';

import 'booking_summary_screen.dart';
import 'utils/schedule_utils.dart';
import 'widgets/day_from_calendar_button.dart';
import 'widgets/title_bar_with_back_button.dart';

class BookingSchedule extends StatefulWidget {
  final SalonModel salon;
  final List<Services> services;
  final Future<List<SalonSchedule>> schedule;
  final Future<List<SalonWorkingHours>> workingHours;
  final int amountOfTimeslots;
  final num price;
  final int duration;

  const BookingSchedule({
    super.key,
    required this.salon,
    required this.services,
    required this.schedule,
    required this.workingHours,
    required this.amountOfTimeslots,
    required this.price,
    required this.duration,
  });

  @override
  _BookingScheduleState createState() => _BookingScheduleState();
}

class _BookingScheduleState extends State<BookingSchedule> {
  final DateTime _startDate = DateTime.now();
  DateTime? selectedDate;
  List<SalonSchedule> selectedDaySlots = [];
  SalonSchedule? selectedSlot;

  bool isPressed = false;

  static const double rowHeight = 65.0;
  static const int slotsPerRow = 3;

  Widget buildSlotsContainer(List<SalonSchedule> slots) {
    int numberOfRows = (slots.length / slotsPerRow).ceil();
    double containerHeight = numberOfRows * rowHeight / 1.5;

    return SizedBox(
      height: containerHeight,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: slotsPerRow,
          childAspectRatio: 3,
        ),
        itemCount: slots.length,
        itemBuilder: (context, index) {
          return buildTimeSlotButton(slots[index]);
        },
      ),
    );
  }

  Widget buildTimeSlotButton(SalonSchedule currentSlot) {
    bool isSelected = selectedSlot == currentSlot;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentColor : Colors.white,
          border: Border.all(color: const Color.fromARGB(54, 255, 128, 0)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedSlot = isSelected ? null : currentSlot;
            });
          },
          child: Text(
            formatTime(currentSlot.timeFrom),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilding UI for selectedDate: $selectedDate');
    initializeDateFormatting('pl_PL', null);
    double itemHeight = MediaQuery.of(context).size.height * 0.12;
    double itemWidth = MediaQuery.of(context).size.width * 0.2;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const TitleBarWithBackButton(
                  title: 'Select Time and Date',
                ),
              ),
              FutureBuilder<List<SalonSchedule>>(
                future: widget.schedule,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Wystąpił błąd: ${snapshot.error}'));
                    }
                    List<SalonSchedule> schedules = snapshot.data ?? [];

                    if (schedules.isEmpty) {
                      return const Center(
                          child: Text('Niestety brak wolnych terminów'));
                    }
                    List<SalonSchedule> availableSlots =
                        filterAvailableTimeSlots(
                            schedules, widget.amountOfTimeslots);

                    Map<DateTime, List<SalonSchedule>> dayToTimeSlots =
                        mapTimeSlotsToDays(availableSlots);

                    // Find the first available date with time slots
                    DateTime firstAvailableDate = _startDate;
                    while (!dayToTimeSlots
                        .containsKey(normalizeDate(firstAvailableDate))) {
                      firstAvailableDate =
                          firstAvailableDate.add(const Duration(days: 1));
                    }

                    // Select the first available date
                    if (!isPressed) {
                      selectedDate = firstAvailableDate;
                    }

                    selectedDaySlots =
                        dayToTimeSlots[normalizeDate(selectedDate!)] ?? [];

                    // Separate slots into morning and afternoon
                    List<SalonSchedule> morningSlots =
                        selectedDaySlots.where((slot) {
                      final hour = int.parse(slot.timeFrom.split(':')[0]);
                      return hour < 12;
                    }).toList();

                    List<SalonSchedule> afternoonSlots =
                        selectedDaySlots.where((slot) {
                      final hour = int.parse(slot.timeFrom.split(':')[0]);
                      return hour >= 12;
                    }).toList();

                    return Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ConstsWidgets.gapH16,
                            SizedBox(
                              height: itemHeight,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 31,
                                itemBuilder: (context, index) {
                                  DateTime currentDate =
                                      _startDate.add(Duration(days: index));
                                  bool isCurrentDateSelected =
                                      selectedDate == currentDate;
                                  String day =
                                      DateFormat('d').format(currentDate);
                                  String weekday = DateFormat('E', 'pl_PL')
                                      .format(currentDate);
                                  bool hasTimeSlots = dayToTimeSlots
                                      .containsKey(normalizeDate(currentDate));

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(50.0),
                                    onTap: hasTimeSlots
                                        ? () {
                                            print(
                                                'Tapped on date: $currentDate');
                                            setState(() {
                                              isPressed = true;
                                              selectedSlot = null;
                                              selectedDate = currentDate;
                                              selectedDaySlots = dayToTimeSlots[
                                                      normalizeDate(
                                                          currentDate)] ??
                                                  [];
                                            });
                                          }
                                        : null,
                                    child: dayFromCalendar(
                                      itemWidth: itemWidth,
                                      isCurrentDateSelected:
                                          isCurrentDateSelected,
                                      hasTimeSlots: hasTimeSlots,
                                      day: day,
                                      weekday: weekday,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (morningSlots.isNotEmpty) ...[
                                  ConstsWidgets.gapH20,
                                  const Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: Text("Morning"),
                                  ),
                                  ConstsWidgets.gapH12,
                                  buildSlotsContainer(morningSlots),
                                ],
                                if (afternoonSlots.isNotEmpty) ...[
                                  ConstsWidgets.gapH20,
                                  const Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: Text("Afternoon"),
                                  ),
                                  ConstsWidgets.gapH12,
                                  buildSlotsContainer(afternoonSlots),
                                ],
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedDate != null && selectedSlot != null
          ? Container(
              color: AppColors.accentColor,
              child: TextButton(
                onPressed: () {
                  List<SalonSchedule> selectedAndNextSlots = [];
                  int selectedSlotIndex =
                      selectedDaySlots.indexOf(selectedSlot!);
                  for (int i = 0; i < widget.amountOfTimeslots; i++) {
                    if (selectedSlotIndex + i < selectedDaySlots.length) {
                      selectedAndNextSlots
                          .add(selectedDaySlots[selectedSlotIndex + i]);
                    }
                  }
                  Get.to(() => BookingSummaryScreen(
                        salon: widget.salon,
                        selectedDate: selectedDate!,
                        selectedTimeSlots: selectedAndNextSlots,
                        duration: widget.duration,
                        price: widget.price,
                        services: widget.services,
                      ));
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Rezerwuj',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

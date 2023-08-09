import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';

class BookingSchedule extends StatefulWidget {
  final SalonModel salon;
  final List<Services> services;
  final Future<List<SalonSchedule>> schedule;
  final Future<List<SalonWorkingHours>> workingHours;

  const BookingSchedule(
      {super.key, required this.salon,
      required this.services,
      required this.schedule,
      required this.workingHours});

  @override
  _BookingScheduleState createState() => _BookingScheduleState();
}

class _BookingScheduleState extends State<BookingSchedule> {
  late DateTime _currentDate;
  late PageController _pageController;
  late int _currentPageIndex;

  @override
  void initState() {
    _currentDate = DateTime.now();
    _currentPageIndex = 0;
    _pageController = PageController(initialPage: _currentPageIndex);
    _pageController.addListener(() {
      int currentPage = _pageController.page!.round();
      if (currentPage != _currentPageIndex) {
        _currentDate = _currentDate
            .add(Duration(days: 7 * (currentPage - _currentPageIndex)));
        _currentPageIndex = currentPage;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _buildDays() {
    List<Widget> days = [];
    for (int i = 0; i < 7; i++) {
      DateTime day = _currentDate.add(Duration(days: i));
      days.add(
        Text(day.day.toString()),
      );
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Navigation'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Nawigacja miesiąca
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {},
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('MMMM').format(_currentDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateFormat('y').format(_currentDate),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
              ],
            ),
            // Dni tygodnia
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Mon'),
                Text('Tue'),
                Text('Wed'),
                Text('Thu'),
                Text('Fri'),
                Text('Sat'),
                Text('Sun'),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 5,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildDays(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

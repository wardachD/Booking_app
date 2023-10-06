import 'dart:convert';
import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/eula/terms_and_condition.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/widgets/popup_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'booking_confirmation_screen.dart';
import 'widgets/title_bar_with_back_button.dart';

class BookingSummaryScreen extends StatefulWidget {
  final SalonModel salon;
  final List<Services> services;
  final DateTime selectedDate;
  final List<SalonSchedule> selectedTimeSlots;
  final num price;
  final int duration;

  const BookingSummaryScreen({
    super.key,
    required this.salon,
    required this.selectedDate,
    required this.selectedTimeSlots,
    required this.services,
    required this.price,
    required this.duration,
  });

  @override
  _BookingSummaryScreenState createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen>
    with WidgetsBindingObserver {
  String userComment = '';
  bool termsAccepted = false;
  bool isBookingInProgress = false;
  bool isSuccess = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Add this widget as an observer to listen for keyboard visibility changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataProvider>(context).user;
    List bookingServicesID =
        widget.services.map((service) => service.id).toList();
    List bookingSelectedTimeSlotsID =
        widget.selectedTimeSlots.map((timeSlot) => timeSlot.id).toList();
    final Map<String, dynamic> data = {
      "salon": widget.salon.id,
      "customer": user?.uid,
      "services": bookingServicesID,
      "comment": userComment,
      "timeslots": bookingSelectedTimeSlotsID,
    };
    final String jsonBookingData = jsonEncode(data);
    print(jsonBookingData);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const TitleBarWithBackButton(
                  title: 'Final Confirmation',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.salon.avatar,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'salon',
                          style: GoogleFonts.anybody(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(widget.salon.name),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'date',
                          style: GoogleFonts.anybody(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            '${widget.selectedDate.year.toString()} - ${widget.selectedDate.month.toString()} - ${widget.selectedDate.day}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'time',
                          style: GoogleFonts.anybody(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text((widget.selectedTimeSlots[0].timeFrom.toString())
                            .substring(
                                0,
                                widget.selectedTimeSlots[0].timeFrom
                                        .toString()
                                        .length -
                                    3)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'price',
                          style: GoogleFonts.anybody(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('€${widget.price.toString()}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'services',
                          style: GoogleFonts.anybody(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ListView.builder(
                              itemCount: widget.services.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  widget.services[index].description,
                                  textAlign: TextAlign.right,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          userComment =
                              value; // Aktualizacja userComment po wprowadzeniu tekstu
                        });
                      },
                      decoration: const InputDecoration(
                        labelText:
                            'Do you want to add something?', // Etykieta dla pola tekstowego
                        // Ramka wokół pola tekstowego
                      ),
                    ),
                    if (!_isKeyboardVisible) const SizedBox(height: 48),
                    if (!_isKeyboardVisible)
                      Row(
                        children: [
                          Checkbox(
                            value: termsAccepted,
                            onChanged: (bool? newValue) {
                              // Ta funkcja jest wywoływana, gdy użytkownik zmienia stan checkboxa
                              // Aktualizujemy stan termsAccepted na podstawie wartości newValue
                              setState(() {
                                termsAccepted = newValue!;
                              });
                              print(termsAccepted);
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'I state that I have read and understood the ',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 34, 34, 34)),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'terms and conditions',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration
                                          .underline, // Podkreślenie tekstu
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const PopupDialog(
                                              text: termsAndCondition,
                                              title: 'Terms and Conditions',
                                            );
                                          },
                                        );
                                      },
                                  ),
                                  const TextSpan(
                                    text: '.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (!_isKeyboardVisible) const SizedBox(height: 16),
                    if (!_isKeyboardVisible)
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: termsAccepted
                                ? () async {
                                    setState(() {
                                      isBookingInProgress =
                                          true; // Set booking status to true
                                    });
                                    var bookingResult =
                                        await sendPostRequest(data);
                                    setState(() {
                                      if (bookingResult == 'success') {
                                        isSuccess = true;
                                        Get.to(() => BookingConfirmationScreen(
                                              response: bookingResult,
                                            ));
                                      } else {
                                        isSuccess = false;
                                      }
                                      isBookingInProgress =
                                          false; // Reset booking status
                                    });
                                  }
                                : null,
                            child: const Text('Confirm Booking'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

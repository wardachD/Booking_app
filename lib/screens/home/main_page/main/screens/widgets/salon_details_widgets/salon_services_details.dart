import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/main_page/main/screens/Booking/screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SalonServicesDetails extends StatefulWidget {
  final SalonModel salonModel;

  const SalonServicesDetails({super.key, required this.salonModel});

  @override
  _SalonServicesDetailsState createState() => _SalonServicesDetailsState();
}

class _SalonServicesDetailsState extends State<SalonServicesDetails> {
  Set<Services> selectedServices = {};
  late Future<List<SalonSchedule>> futureSalonSchedules;
  late Future<List<SalonWorkingHours>> futureSalonWorkingHours;

  void _toggleService(Services service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    futureSalonSchedules =
        fetchSalonSchedules(http.Client(), widget.salonModel.id);
    futureSalonWorkingHours =
        fetchSalonWorkingHours(http.Client(), widget.salonModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.salonModel.categories.length,
          itemBuilder: (context, index) {
            return Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: index == 0 ? Colors.transparent : Colors.grey,
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: index == widget.salonModel.categories.length - 1
                          ? Colors.grey
                          : Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(widget.salonModel.categories[index].name),
                  ),
                  children: widget.salonModel.categories[index].services
                      .map<Widget>((service) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(service.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(service.description),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('${service.price} zł',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('${service.durationMinutes}m'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedServices
                                        .contains(service)
                                    ? Colors.blue
                                    : null, // set color to blue if service is selected
                              ),
                              onPressed: () {
                                _toggleService(service);
                              },
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        if (selectedServices.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                child: const Text('Zarezerwuj'),
                onPressed: () {
                  Get.to(() => BookingScreen(
                        salon: widget.salonModel,
                        services: selectedServices.toList(),
                        schedule: futureSalonSchedules,
                        workingHours: futureSalonWorkingHours,
                      ));
                },
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MapButton extends StatelessWidget {
  final String city;
  final String street;
  final String streetNumber;
  final String postcode;
  final String phoneNumber;

  const MapButton({
    super.key,
    required this.city,
    required this.street,
    required this.streetNumber,
    required this.postcode,
    required this.phoneNumber,
  });

  void openMaps() async {
    String formattedAddress = '$street $streetNumber, $postcode $city';
    MapsLauncher.launchQuery(formattedAddress);
  }

  _callNumber(phoneNumber) async {
    String number = phoneNumber; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              _callNumber(phoneNumber);
            },
            child: Container(
                width: 120,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color.fromARGB(255, 32, 32, 32),
                        width: 0.7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(MdiIcons.phone),
                    Text('Zadzwoń'),
                  ],
                )),
          ),
          GestureDetector(
            onTap: () {
              openMaps();
            },
            child: Container(
                width: 120,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Color.fromARGB(255, 32, 32, 32), width: 0.7)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(MdiIcons.googleMaps),
                          const Text('Nawiguj'),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

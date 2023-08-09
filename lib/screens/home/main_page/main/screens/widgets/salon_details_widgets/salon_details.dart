import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SalonDetails extends StatelessWidget {
  final SalonModel salonModel;
  const SalonDetails({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String locationString = salonModel.location;

    RegExp regExp = RegExp(r"(\d+\.\d+)");

    Iterable<RegExpMatch> matches = regExp.allMatches(locationString);

    double latitude = double.parse(matches.elementAt(0).group(0) ?? '0');
    double longitude = double.parse(matches.elementAt(1).group(0) ?? '0');

    LatLng latLng = LatLng(latitude, longitude);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: FlutterMap(
                  options: MapOptions(
                    center: latLng,
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: latLng,
                          builder: (ctx) => const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ABOUT US',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 5),
                    Text(
                      "${salonModel.about} there are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
                      style: const TextStyle(
                          letterSpacing: 0.7,
                          fontSize: 14,
                          color: Color.fromARGB(255, 90, 89, 89)),
                    ),
                    const SizedBox(height: 25),
                    Text('OUR STAFF',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List<Widget>.generate(
                          6,
                          (index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 13.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 75.0,
                                    height: 75.0,
                                    color: Colors.white,
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'http://185.180.204.182/avatar.gif'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'MAJA ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.7,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 90, 89, 89)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  launchUrl("tel:${salonModel.phoneNumber}" as Uri),
              icon: const Icon(Icons.phone),
              label: Text(salonModel.phoneNumber),
            ),
          ],
        ),
      ),
    );
  }
}

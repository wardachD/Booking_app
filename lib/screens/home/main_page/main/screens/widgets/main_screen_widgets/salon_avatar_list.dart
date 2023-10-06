import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';

class SalonAvatarList extends StatelessWidget {
  final List<SalonModel> salons;

  const SalonAvatarList({super.key, required this.salons});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          children: salons.map((salon) => SalonAvatar(salon: salon)).toList(),
        ),
      ),
    );
  }
}

class SalonAvatar extends StatelessWidget {
  final SalonModel salon;

  const SalonAvatar({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 20),
      child: FutureBuilder<String>(
        future: getPhoto(salon.avatar),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Wyświetlamy CircularProgressIndicator, gdy trwa pobieranie obrazka
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Obsługa błędów
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Center(
                child: Text('An error has occurred!'),
              ),
            );
          } else {
            return GestureDetector(
                onTap: () =>
                    Get.to(() => SalonDetailsScreen(salonModel: salon)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: 15,
                          bottom: 15.0,
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.11,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Text(salon.name,
                                      style: GoogleFonts.anybody(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: Color.fromARGB(255, 57, 57, 57),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${salon.addressCity}, ${salon.addressStreet}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 57, 57, 57)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: MediaQuery.sizeOf(context).width * 0.6,
                          top: 15.0,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 5, 0, 5),
                                  child: Icon(
                                    MdiIcons.star,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
                                  child: Text(
                                    "4.8",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }
        },
      ),
    );
  }
}

class SalonListElementAwait extends StatelessWidget {
  const SalonListElementAwait({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          children: List.generate(
            6,
            (index) => Padding(
              padding: EdgeInsets.only(
                right: (index == 5) ? 25.0 : 8.0,
                bottom: 20,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset(
                  'assets/gifs/background-placeholder.gif',
                  fit: BoxFit
                      .cover, // Ustawia BoxFit.cover dla wypełnienia całości obrazka
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

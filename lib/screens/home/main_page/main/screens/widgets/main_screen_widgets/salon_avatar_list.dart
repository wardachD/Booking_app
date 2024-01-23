import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class SalonAvatarList extends StatelessWidget {
  final List<SalonModel> salons;

  const SalonAvatarList({super.key, required this.salons});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 0, 15),
          child: Text(
            'Dla Ciebie',
            textAlign: TextAlign.start,
            style: TextStyle(
                letterSpacing: 0.1,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color.fromARGB(255, 22, 22, 22)),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children:
                  salons.map((salon) => SalonAvatar(salon: salon)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class SalonAvatar extends StatefulWidget {
  final SalonModel salon;

  const SalonAvatar({Key? key, required this.salon}) : super(key: key);

  @override
  State<SalonAvatar> createState() => _SalonAvatarState();
}

class _SalonAvatarState extends State<SalonAvatar> {
  late FavoriteSalonsProvider userDataProvider;
  late bool isSalonFavorite;

  @override
  void initState() {
    super.initState();
    userDataProvider =
        Provider.of<FavoriteSalonsProvider>(context, listen: false);
    isSalonFavorite = userDataProvider.salons.contains(widget.salon);
  }

  @override
  Widget build(BuildContext context) {
    var userDataProvider =
        Provider.of<FavoriteSalonsProvider>(context, listen: false);
    FavoriteSalonsProvider favoriteSalonsProvider = FavoriteSalonsProvider();
    bool isSalonFavorite = userDataProvider.salons.contains(widget.salon);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 20),
      child: FutureBuilder<String>(
        future: getPhoto(widget.salon.avatar),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Wyświetlamy CircularProgressIndicator, gdy trwa pobieranie obrazka
            return const SizedBox(
                // width: MediaQuery.of(context).size.width * 0.7,
                // height: MediaQuery.of(context).size.height * 0.35,
                // child: const Center(
                //   child: CircularProgressIndicator(),
                // ),
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
                  Get.to(() => SalonDetailsScreen(salonModel: widget.salon)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
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
                      if (widget.salon.review != 0.1)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(88, 0, 0, 0),
                                      blurRadius: 16.0)
                                ]),
                            height: MediaQuery.sizeOf(context).height * 0.06,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                if (widget.salon.review != 0.1)
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 209, 209, 209),
                                      ),
                                      child: Text(
                                        widget.salon.review.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 31, 31, 31),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (widget.salon.review != 0.1)
                                  SmoothStarRating(
                                    rating: widget.salon.review,
                                    size: 20,
                                    color: Colors.orangeAccent,
                                    borderColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    filledIconData: Icons.star,
                                    halfFilledIconData: Icons.star_half,
                                    defaultIconData: Icons.star_border,
                                    starCount: 5,
                                    allowHalfRating: true,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.salon.review == 0.1)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.06,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 209, 209, 209),
                                    ),
                                    child: const Text(
                                      'Brak ocen',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 31, 31, 31),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.12,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 243, 243, 243),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: Text(
                                  widget.salon.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.navigation,
                                      size: 16,
                                      color: Color.fromARGB(255, 83, 83, 83),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(widget.salon.distanceFromQuery / 1000).toStringAsFixed(1)} km',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 83, 83, 83),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Color.fromARGB(255, 57, 57, 57),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.salon.addressCity}, ${widget.salon.addressStreet}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 57, 57, 57)),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ConstsWidgets.gapW16,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: AnimateGradient(
                      duration: const Duration(milliseconds: 1200),
                      primaryBegin: Alignment.centerRight,
                      primaryEnd: Alignment.centerRight,
                      secondaryBegin: Alignment.centerLeft,
                      secondaryEnd: Alignment.centerLeft,
                      primaryColors: [
                        const Color.fromARGB(202, 255, 255, 255),
                        const Color.fromARGB(160, 255, 172, 64)
                      ],
                      secondaryColors: [
                        const Color.fromARGB(113, 255, 172, 64),
                        const Color.fromARGB(101, 255, 255, 255)
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SalonElementAwait extends StatelessWidget {
  const SalonElementAwait({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.72,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 25.0,
          top: 10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimateGradient(
              duration: const Duration(milliseconds: 1200),
              primaryBegin: Alignment.centerRight,
              primaryEnd: Alignment.centerRight,
              secondaryBegin: Alignment.centerLeft,
              secondaryEnd: Alignment.centerLeft,
              primaryColors: [
                const Color.fromARGB(202, 255, 255, 255),
                const Color.fromARGB(160, 255, 172, 64)
              ],
              secondaryColors: [
                const Color.fromARGB(113, 255, 172, 64),
                const Color.fromARGB(101, 255, 255, 255)
              ]),
        ),
      ),
    );
  }
}

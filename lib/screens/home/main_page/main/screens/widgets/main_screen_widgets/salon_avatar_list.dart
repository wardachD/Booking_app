import 'dart:math';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/category_tile.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/list_of_categories.dart';
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
              children: salons
                  .map((salon) => SalonAvatar(
                        salon: salon,
                        showDistanes: false,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class SalonAvatar extends StatefulWidget {
  final SalonModel salon;
  final bool showDistanes;

  const SalonAvatar({Key? key, required this.salon, required this.showDistanes})
      : super(key: key);

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
                                        color: AppColors.lightColorTextField,
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
                                    borderColor: AppColors.lightColorTextField,
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
                                      color: AppColors.lightColorTextField,
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
                          height: 250,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  category(
                                      categoryName:
                                          widget.salon.flutterCategory),
                                  if (widget.showDistanes)
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          MdiIcons.circle,
                                          size: 3,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.navigation,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${(widget.salon.distanceFromQuery / 1000).toStringAsFixed(1)} km',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (widget.salon.salonProperties.contains(6))
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          MdiIcons.circle,
                                          size: 3,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                MdiIcons.car,
                                                size: 16,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Dojazd do klienta',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                          200, // Adjust the width according to your needs
                                      child: Text(
                                        '${widget.salon.addressCity} ${widget.salon.addressPostalCode}, ${widget.salon.addressStreet} ${widget.salon.addressNumber}',
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.white),
                                        softWrap: true,
                                      ),
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: Text(
                                  widget.salon.name,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                  softWrap: true,
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

class CompactSalonTile extends StatelessWidget {
  final SalonModel salon;
  final bool showDistances;

  CompactSalonTile({Key? key, required this.salon, required this.showDistances})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => SalonDetailsScreen(salonModel: salon)),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        height: 135, // Adjust height as needed
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(62, 126, 126, 126),
                  blurRadius: 2,
                  offset: Offset(0, 3))
            ]),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Image on the left
              Container(
                width: 130,
                height: 130,
                // Adjust width as needed
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: salon.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Text on the right
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          compactCategoryDistanceReview(
                            categoryName: salon.flutterCategory,
                            review: salon.review,
                            distance: salon.distanceFromQuery,
                            showDistances: showDistances,
                          ),
                          if (salon.salonProperties.contains(6))
                            Icon(
                              MdiIcons.circle,
                              size: 4,
                              color: Color.fromARGB(255, 167, 167, 167),
                            ),
                          if (salon.salonProperties.contains(6))
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    MdiIcons.car,
                                    size: 16,
                                    color: Color.fromARGB(255, 56, 56, 56),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Dojazd do klienta',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 56, 56, 56),
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            salon.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${salon.addressCity} ${salon.addressPostalCode}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 61, 61, 61),
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                MdiIcons.star,
                                size: 16,
                                color: salon.review != 0.1
                                    ? Colors.orange
                                    : Color.fromARGB(255, 61, 61, 61),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                salon.review != 0.1
                                    ? salon.review.toString()
                                    : 'Brak',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          if (showDistances)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(MdiIcons.navigation,
                                    size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  getFormattedDistance(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                        ],
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

  String getFormattedDistance() {
    if (salon.distanceFromQuery >= 1000) {
      return '${(salon.distanceFromQuery / 1000).toStringAsFixed(1)} km';
    } else {
      return '${salon.distanceFromQuery.toInt()} m';
    }
  }
}

class category extends StatelessWidget {
  final String categoryName;

  category({
    super.key,
    required this.categoryName,
  });

  int categoryOption = 0;

  @override
  Widget build(BuildContext context) {
    switch (categoryName) {
      case 'hairdresser':
        categoryOption = 0;
        break;
      case 'nails':
        categoryOption = 1;
        break;
      case 'massage':
        categoryOption = 2;
        break;
      case 'barber':
        categoryOption = 3;
        break;
      case 'makeup':
        categoryOption = 4;
        break;
      case 'pedicure':
        categoryOption = 5;
        break;
      case 'manicure':
        categoryOption = 6;
        break;
    }

    return Row(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromARGB(255, 180, 180, 180)),
          color: AppColors.lightColorTextField,
        ),
        child: CategoryTile(
          customCategoryItem: categoryCustomList[categoryOption],
          iconHeight: 18,
          textSize: 12,
        ),
      ),
    ]);
  }
}

class compactCategoryDistanceReview extends StatelessWidget {
  final String categoryName;
  final num distance;
  final double review;
  final bool showDistances;

  compactCategoryDistanceReview({
    super.key,
    required this.categoryName,
    required this.distance,
    required this.review,
    required this.showDistances,
  });

  int categoryOption = 0;

  @override
  Widget build(BuildContext context) {
    switch (categoryName) {
      case 'hairdresser':
        categoryOption = 0;
        break;
      case 'nails':
        categoryOption = 1;
        break;
      case 'massage':
        categoryOption = 2;
        break;
      case 'barber':
        categoryOption = 3;
        break;
      case 'makeup':
        categoryOption = 4;
        break;
      case 'pedicure':
        categoryOption = 5;
        break;
      case 'manicure':
        categoryOption = 6;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Category
        Container(
          child: CategoryTile(
            customCategoryItem: categoryCustomList[categoryOption],
            iconHeight: 18,
            textSize: 12,
            isIconDisabled: true,
            fontColor: const Color.fromARGB(255, 68, 68, 68),
          ),
        ),

        // Review and Distance
      ],
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

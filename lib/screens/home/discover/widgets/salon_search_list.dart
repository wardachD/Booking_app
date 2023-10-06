import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalonSearchList extends StatelessWidget {
  final Future<List<SalonModel>> salonsSearchFuture;
  final bool isDistanceNeeded;

  const SalonSearchList(
      {super.key,
      required this.salonsSearchFuture,
      required this.isDistanceNeeded});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SalonModel>>(
      future: salonsSearchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var salons = snapshot.data;
          if (salons!.isEmpty) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/gifs/empty.gif',
                        width: MediaQuery.sizeOf(context).width * 0.6),
                    const SizedBox(height: 10),
                    const Text("Empty in here mate :("),
                  ]),
            );
          }

          return ListView.builder(
            itemCount: salons.length,
            itemBuilder: (context, index) {
              var salon = salons[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to SalonDetailsScreen when a salon is tapped
                  Get.to(() => SalonDetailsScreen(salonModel: salon));
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(salon.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star),
                                Text('4.8'),
                              ],
                            ),
                          ),
                          if (isDistanceNeeded == true)
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.navigation),
                                  Text(
                                      '${(salon.distanceFromQuery / 1000).toStringAsFixed(1)}km'),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              salon.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: AppColors.primaryLightColorText),
                                Text(
                                  '${salon.addressCity}, ${salon.addressPostalCode}, ${salon.addressStreet}',
                                  style: const TextStyle(
                                      color: AppColors.primaryLightColorText),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

import 'package:findovio/providers/advertisements_provider.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/advertisements_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvertisementsWidget extends StatelessWidget {
  final String optionalString;
  const AdvertisementsWidget({super.key, required this.optionalString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AdvertisementProvider>(
            builder: (context, provider, child) {
              final advertisements = provider.advertisements;

              if (advertisements.isEmpty) {
                // No upcoming appointments
                return const SizedBox.shrink();
              } else {
                // Display the list of upcoming appointments
                return AdvertisementsTiles(
                    advertisements: advertisements,
                    optionalString: optionalString);
              }
            },
          ),
        ],
      ),
    );
  }
}

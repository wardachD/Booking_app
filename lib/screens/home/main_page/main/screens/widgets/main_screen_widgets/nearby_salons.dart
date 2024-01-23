import 'package:findovio/models/salon_model.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/salon_avatar_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart'; // Import your FirebasePyUserProvider

class NearbySalons extends StatelessWidget {
  const NearbySalons({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<FirebasePyUserProvider, List<SalonModel>>(
      selector: (_, provider) =>
          provider.salons ?? [], // Replace with your logic
      builder: (context, salons, _) {
        if (salons.isEmpty) {
          return const Center(
            child: SalonListElementAwait(), // Or any loading indicator
          );
        } else {
          return SalonAvatarList(salons: salons);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'salon_avatar_list.dart';

class NearbySalons extends StatelessWidget {
  const NearbySalons({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SalonModel>>(
      future: fetchSalons(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return SalonAvatarList(salons: snapshot.data!);
        } else {
          return const Center(
            child: SalonListElementAwait(),
          );
        }
      },
    );
  }
}

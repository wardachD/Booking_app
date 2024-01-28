import 'package:findovio/consts.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/salon_avatar_list.dart';
import 'package:findovio/widgets/custom_horizontal_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteBottomSheet extends StatefulWidget {
  @override
  _FavoriteBottomSheetState createState() => _FavoriteBottomSheetState();
}

class _FavoriteBottomSheetState extends State<FavoriteBottomSheet> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDataProvider =
        Provider.of<FavoriteSalonsProvider>(context, listen: false);

    return GestureDetector(
      // Listen to the vertical and horizontal drags
      onVerticalDragUpdate: (details) {},
      onHorizontalDragUpdate: (details) {
        Navigator.pop(context); // Close bottom sheet on horizontal scroll
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(), // Adjust physics as needed
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 6, 25, 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ulubione',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 20, 20, 20),
                  fontWeight: FontWeight.w500,
                ),
              ),
              ConstsWidgets.gapH12,
              const Text(
                'Tutaj są Twoje ulubione salony. Chcesz któryś usunąć? Wejdź na profil salonu i kliknij serduszko.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromARGB(255, 83, 83, 83),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: userDataProvider.salons
                        .map((salon) => SalonAvatar(
                              salon: salon,
                              showDistanes: false,
                            ))
                        .toList(),
                  ),
                ),
              ),
              // Other widgets
            ],
          ),
        ),
      ),
    );
  }
}

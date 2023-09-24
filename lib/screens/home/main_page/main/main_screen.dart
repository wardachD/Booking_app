import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/upcoming_appointments.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'screens/widgets/main_screen_widgets/nearby_salons.dart';
import 'screens/widgets/main_screen_widgets/list_of_categories.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/search_text_field.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataProvider>(context).user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'howdy ${user?.uid}   ',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.waving_hand_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Container(
                width: double.infinity,
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [SearchTextField()],
                ),
              ),
            ),
            ConstsWidgets.gapH8,
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.16,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                itemCount: categoryCustomList.length,
                itemBuilder: (context, index) {
                  var customCategoryItem = categoryCustomList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: (() => Get.find<BottomAppBarIndexController>()
                          .setBottomAppBarIndex(1)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          color: customCategoryItem.color,
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
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(customCategoryItem.icon, size: 32),
                              ConstsWidgets.gapH16,
                              Text(
                                customCategoryItem.title,
                                style: GoogleFonts.playfairDisplay(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            UpcomingAppointments(userId: user!.uid),
            ConstsWidgets.gapH8,
            const NearbySalons(),
          ],
        ),
      ),
    );
  }
}

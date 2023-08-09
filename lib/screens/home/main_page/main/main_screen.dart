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
              height: 10,
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
            SizedBox(
                height: 25,
                width: MediaQuery.sizeOf(context).width * 0.85,
                child: Text("let's find it!",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ))),
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
                              const SizedBox(height: 18),
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
            SizedBox(
                height: 30,
                width: MediaQuery.sizeOf(context).width * 0.85,
                child: Text("what for today?",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ))),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 2), // zmienia położenie cieni
                    ),
                  ],
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.14,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'discover new salons',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.find<BottomAppBarIndexController>()
                        .setBottomAppBarIndex(1),
                    child: Row(
                      children: [
                        Text(
                          'more',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right_sharp),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const NearbySalons(),
          ],
        ),
      ),
    );
  }
}

import 'package:findovio/consts.dart';
import 'package:findovio/globals/user_data_global.dart';
import 'package:findovio/models/firebase_py_get_model.dart';
import 'package:findovio/models/firebase_py_register_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/main_page/main/controllers/firebase_logout.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/banner_card.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/upcoming_appointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'screens/widgets/main_screen_widgets/nearby_salons.dart';
import 'screens/widgets/main_screen_widgets/list_of_categories.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/search_text_field.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<FirebasePyGetModel> userPy;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userPy = fetchFirebasePyUser(http.Client(), user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<FirebasePyGetModel>(
                      future: userPy,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Row(
                              children: [
                                Text(
                                  'hej, ${snapshot.data?.firebaseName}  ',
                                  style: GoogleFonts.anybody(
                                    letterSpacing: 0.1,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                                const Icon(Icons.waving_hand_outlined),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Error loading user data');
                          }
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.035,
                      width: MediaQuery.sizeOf(context).height * 0.035,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 1.0,
                            )
                          ]),
                      child: GestureDetector(
                        onTap: () => signOut(),
                        child: const Icon(Icons.logout_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstsWidgets.gapH8,
            // Search bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [SearchTextField()],
                ),
              ),
            ),
            ConstsWidgets.gapH16,
            //Banner
            BannerCard(),
            ConstsWidgets.gapH12,
            // Categories
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.16,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                itemCount: categoryCustomList.length,
                itemBuilder: (context, index) {
                  var customCategoryItem = categoryCustomList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: (() {
                        Get.find<BottomAppBarIndexController>()
                            .setBottomAppBarIndexWithCategory(
                                1, categoryCustomList[index].title);
                      }),
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
                                style: GoogleFonts.anybody(
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
            // Upcoming appointments - disabled when no appointments coming in
            UpcomingAppointments(userId: user!.uid),
            // Nearby salons
            const NearbySalons(),
          ],
        ),
      ),
    );
  }
}

Future signOut() async {
  try {
    FirebaseAuth.instance.signOut;
    Get.offAllNamed(Routes.INTRO);
  } catch (e) {
    print('Error during logout: $e');
  }
}

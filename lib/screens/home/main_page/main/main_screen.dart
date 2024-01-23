import 'dart:io';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/models/firebase_py_get_model.dart';
import 'package:findovio/providers/advertisements_provider.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/discover/provider/optional_category_provider.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/findovio_advertisement_widget.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/category_tile.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/upcoming_appointments.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/advertisements_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/widgets/main_screen_widgets/nearby_salons.dart';
import 'screens/widgets/main_screen_widgets/list_of_categories.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/search_text_field.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late User? user;
  late FirebasePyGetModel? userPy;

  @override
  void initState() {
    super.initState();
    if (Provider.of<FirebasePyUserProvider>(context, listen: false).user ==
        null) {
      Provider.of<AdvertisementProvider>(context, listen: false)
          .fetchAdvertisements();
      Provider.of<FirebasePyUserProvider>(context, listen: false).fetchData();
    }
  }

  final animateGradient = AnimateGradient(
      duration: const Duration(milliseconds: 1200),
      primaryBegin: Alignment.centerRight,
      primaryEnd: Alignment.centerRight,
      secondaryBegin: Alignment.centerLeft,
      secondaryEnd: Alignment.centerLeft,
      primaryColors: [
        Color.fromARGB(202, 255, 255, 255),
        Color.fromARGB(160, 255, 172, 64)
      ],
      secondaryColors: [
        Color.fromARGB(113, 255, 172, 64),
        Color.fromARGB(101, 255, 255, 255)
      ]);

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;
    userPy = Provider.of<FirebasePyUserProvider>(context).user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 19.0),
              child: Stack(
                children: [
                  // Orange line background
                  if (userPy?.firebaseName != null)
                    Container(
                      margin: const EdgeInsets.only(top: 18.0),
                      clipBehavior: Clip.none,
                      width: MediaQuery.sizeOf(context).width * 0.2,
                      height: 11, // Adjust the height of the line as needed
                      color: Colors.orange,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (userPy?.firebaseName == null)
                            Container(
                              width: 120,
                              height: 24,
                              child: animateGradient,
                            ),
                          if (userPy?.firebaseName != null)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                'hej, ${userPy?.firebaseName}  ',
                                style: const TextStyle(
                                  letterSpacing: 0.1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                          Text('😁'),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: AppColors.lightColorTextField,
                        ),
                        child: GestureDetector(
                          onTap: () => signOut(context),
                          child: const Icon(Icons.logout_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
            ConstsWidgets.gapH4,

            // Search bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [SearchTextField()],
                ),
              ),
            ),

            //Categories
            SizedBox(
              height: 50,
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
                        Provider.of<OptionalCategoryProvider>(context,
                                listen: false)
                            .updateField(categoryCustomList[index].title);
                      }),
                      child: Column(
                        children: [
                          Expanded(
                            child: CategoryTile(
                                customCategoryItem: customCategoryItem),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ConstsWidgets.gapH4,

            //const BannerCard(),
            //ConstsWidgets.gapH12,
            // Upcoming appointments - disabled when no appointments coming in
            if (user != null) UpcomingAppointments(userId: user!.uid),

            //Banner
            const AdvertisementsWidget(optionalString: ''),
            ConstsWidgets.gapH12,

            // Nearby salons
            const NearbySalons(),

            // Findovio Advertisement
            FindovioAdvertisementWidget(),
          ],
        ),
      ),
    );
  }
}

Future<void> _deleteCacheDir() async {
  Directory tempDir = await getTemporaryDirectory();

  if (tempDir.existsSync()) {
    tempDir.deleteSync(recursive: true);
  }
}

Future<void> _deleteAppDir() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();

  if (appDocDir.existsSync()) {
    appDocDir.deleteSync(recursive: true);
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    _deleteAppDir();
    _deleteCacheDir();
    context.read<FirebasePyUserProvider>().clearData();
    Provider.of<UserDataProvider>(context, listen: false).refreshUser();
    Get.offAllNamed(Routes.INTRO);
  } catch (e) {
    print(e);
  }
}

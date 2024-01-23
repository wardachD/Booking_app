import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/models/firebase_py_get_model.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/profile/widgets/popup_private_data.dart';
import 'package:findovio/widgets/title_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final FirebasePyGetModel? userPy =
        Provider.of<FirebasePyUserProvider>(context).user;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 4),
              Stack(children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  clipBehavior: Clip.none,
                  width: MediaQuery.sizeOf(context).width * 0.2,
                  height: 13, // Adjust the height of the line as needed
                  color: Colors.orange,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleBar(text: "twój profil"),
                    Icon(MdiIcons.faceManOutline),
                  ],
                ),
              ]),
              Text(
                userPy!.firebaseName.toString(),
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: 165,
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 255, 203, 135),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.seal,
                      color: Color.fromARGB(255, 58, 58, 58),
                    ),
                    Text(
                      "   Brązowy poziom",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.lightColorTextField,
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCircularIcon(context, Icons.assignment, 'Wizyty'),
                    _buildCircularIcon(context, Icons.favorite, 'Ulubione'),
                    _buildCircularIcon(context, Icons.location_on, 'Mój adres'),
                  ],
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.lightColorTextField,
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      ),
                    ]),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        _buildRow(
                            Icons.person, 'Dane osobiste', false, context),
                        const SizedBox(
                            height:
                                6), // Adjust the space between the divider and the previous icon
                        const Divider(
                          color: AppColors.lightColorTextField,
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(
                            height:
                                6), // Adjust the space between the divider and the next icon
                        _buildRow(Icons.lock, 'Zmień hasło', false, context),
                        const SizedBox(
                            height:
                                6), // Adjust the space between the divider and the next icon
                        const Divider(
                          color: AppColors.lightColorTextField,
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(
                            height:
                                6), // Adjust the space between the divider and the next icon
                        _buildRow(Icons.help, 'FAQ', false, context),
                        const SizedBox(
                            height:
                                6), // Adjust the space between the divider and the next icon
                        const Divider(
                          color: AppColors.lightColorTextField,
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(
                            height:
                                6), // Adjust the space between the divider and the next icon

                        _buildRow(Icons.notifications, 'Powiadomienia', true,
                            context),
                      ],
                    )),
              ),
              Spacer(),
              InkWell(
                splashColor: Color.fromARGB(92, 255, 172, 64),
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await signOut(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orangeAccent, width: 1.5),
                  ),
                  child: Text('Wyloguj'),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
      Provider.of<UserDataProvider>(context, listen: false).refreshUser();
      Provider.of<FavoriteSalonsProvider>(context, listen: false)
          .clearFavorites();
      await _deleteAppDir();
      await _deleteCacheDir();
      context.read<FirebasePyUserProvider>().clearData();
      Get.find<BottomAppBarIndexController>().setBottomAppBarIndex(0);
      Get.offAllNamed(Routes.INTRO);
    } catch (e) {
      print(e);
    }
  }

  // ... existing imports and other code ...

  Widget _buildCircularIcon(BuildContext context, IconData icon, String text) {
    return Container(
      width: 80,
      child: GestureDetector(
        onTap: () {
          // Add your onTap functionality here
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: const Color.fromARGB(45, 255, 153, 0),
            borderRadius:
                BorderRadius.circular(30), // Adjust the border radius as needed
            onTap: () {
              switch (text) {
                case "Wizyty":
                  Get.find<BottomAppBarIndexController>()
                      .setBottomAppBarIndex(2);
                  break;
                case "Ulubione":
                  showUserProfileOptions(context, "Ulubione");
                  break;
                case "Mój adres":
                  showUserProfileOptions(context, "Mój adres");
                  break;
              }
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightColorTextField,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.lightColorTextField, width: 1),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    color: Colors.orangeAccent,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 5),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
      IconData icon, String text, bool isLast, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: const Color.fromARGB(38, 255, 172, 64),
        borderRadius:
            BorderRadius.circular(12), // Adjust the border radius as needed
        onTap: () {
          if (text == 'Powiadomienia') {
            try {
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            } catch (e) {
              AlertDialog(
                content: Text(e.toString()),
              );
            }
          } else {
            showUserProfileOptions(context, text);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          height: 45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: AppColors.lightColorTextField,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(icon, color: Colors.orangeAccent),
                  ),
                  const SizedBox(width: 12),
                  Text(text),
                  const Spacer(),
                  Icon(
                    MdiIcons.chevronRight,
                    color: Color.fromARGB(255, 80, 80, 80),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

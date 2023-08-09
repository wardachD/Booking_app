import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';

SalomonBottomBarItem _bottomBarItem({
  required IconData icon,
  required String title,
  required Color color,
}) {
  return SalomonBottomBarItem(
    icon: Icon(icon),
    title: Text(
      title,
      style: const TextStyle(
        fontFamily: 'Magic',
      ),
    ),
    selectedColor: Colors.grey,
  );
}

class CustomBottomAppBar extends GetView<BottomAppBarIndexController> {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Obx(
        () => SalomonBottomBar(
          currentIndex: controller.activeIndex.value,
          onTap: controller.setBottomAppBarIndex,
          items: [
            _bottomBarItem(
              icon: MdiIcons.home,
              title: 'Home'.tr,
              color: Colors.white,
            ),
            _bottomBarItem(
              icon: MdiIcons.compass,
              title: 'Discover'.tr,
              color: Colors.white,
            ),
            _bottomBarItem(
              icon: MdiIcons.calendarHeart,
              title: 'My Appointments'.tr,
              color: Colors.white,
            ),
            _bottomBarItem(
              icon: MdiIcons.account,
              title: 'Profile'.tr,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

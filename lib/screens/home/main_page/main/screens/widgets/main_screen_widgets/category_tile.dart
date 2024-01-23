import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.customCategoryItem,
  });

  final CategoryItem customCategoryItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.lightColorTextField,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(customCategoryItem.imagePath, height: 25),
          ConstsWidgets.gapW8,
          Text(
            customCategoryItem.title,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

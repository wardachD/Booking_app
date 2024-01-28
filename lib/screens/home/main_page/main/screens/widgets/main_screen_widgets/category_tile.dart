import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  CategoryTile(
      {super.key,
      required this.customCategoryItem,
      this.iconHeight,
      this.textSize,
      this.isIconDisabled,
      this.fontColor});

  final CategoryItem customCategoryItem;
  double? iconHeight;
  double? textSize;
  bool? isIconDisabled;
  Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isIconDisabled == null)
          Image.asset(customCategoryItem.imagePath, height: iconHeight ?? 25),
        if (isIconDisabled == null) ConstsWidgets.gapW8,
        Text(
          customCategoryItem.title,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: textSize ?? 12,
              color: fontColor ?? AppColors.primaryLightColorText),
        ),
      ],
    );
  }
}

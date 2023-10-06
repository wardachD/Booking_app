import 'package:findovio/models/category_card.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:flutter/material.dart';

class SalonCategoriesList extends StatefulWidget {
  final Future<List<SalonModel>> salonsFuture;
  final Future<List<SalonModel>> unfilteredSalonsFuture;
  final Function(String) onCategorySelected;
  const SalonCategoriesList(
      {Key? key,
      required this.salonsFuture,
      required this.unfilteredSalonsFuture,
      required this.onCategorySelected})
      : super(key: key);

  @override
  _SalonCategoriesListState createState() => _SalonCategoriesListState();
}

class _SalonCategoriesListState extends State<SalonCategoriesList> {
  Map<String, bool> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SalonModel>>(
      future: widget.unfilteredSalonsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> listOfCategory = [];
          for (var salon in snapshot.data!) {
            if (!listOfCategory.contains(salon.flutterCategory)) {
              listOfCategory.add(salon.flutterCategory);
            }
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: listOfCategory.map((name) {
                return GestureDetector(
                  onTap: () {
                    widget.onCategorySelected(name);
                    setState(() {
                      if (selectedCategories.containsKey(name)) {
                        selectedCategories[name] = !selectedCategories[name]!;
                      } else {
                        selectedCategories[name] = true;
                      }
                    });
                  },
                  child: CategoryCard(
                    category: name,
                    isSelected: selectedCategories[name] ?? false,
                  ),
                );
              }).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final bool isSelected;

  const CategoryCard({
    required this.category,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: MediaQuery.of(context).size.height * 0.045,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 2), // zmienia położenie cieni
          ),
        ],
        color: isSelected ? Colors.white12 : Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: isSelected
          ? Row(
              children: [
                Text(category),
                const Icon(
                  Icons.close,
                  size: 20,
                ),
              ],
            )
          : Text(category),
    );
  }
}

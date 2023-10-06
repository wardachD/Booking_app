import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/discover/widgets/salon_categories_list.dart';
import 'package:findovio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'input_screen/search_field_screen.dart';
import 'widgets/salon_search_list.dart';

class DiscoverScreen extends StatefulWidget {
  final String? optionalCategry;

  const DiscoverScreen({Key? key, this.optionalCategry}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedDistance = '10'; // Default selected distance
  String? selectedCategory;
  Map<String, bool> selectedCategories = {};

  late Future<List<SalonModel>> searchResult = Future.value([]);
  late Future<List<SalonModel>> filteredSearchResult = Future.value([]);
  late Future<List<SalonModel>> unfilteredSearchResult = Future.value([]);

  final List<String> _distanceOptions = ['2', '5', '10', '30', '50'];

  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late bool _isDistanceNeeded = false;

  @override
  void dispose() {
    _keywordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.backgroundColor,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBarWithoutHeight(text: widget.optionalCategry ?? ''),
              if (widget.optionalCategry != null) ConstsWidgets.gapH12,
              GestureDetector(
                onTap: () {
                  searchResult =
                      _navigateToSearchInputPage(isKeywordSearch: true);
                  filteredSearchResult = searchResult;
                  unfilteredSearchResult = searchResult;
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _keywordController.text.isNotEmpty
                              ? _keywordController.text
                              : 'Co dzisiaj szukasz?',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                      ),
                      if (_keywordController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _keywordController.text = '';
                            });
                            searchResult = _onTapSearch();
                            filteredSearchResult = searchResult;
                            unfilteredSearchResult = searchResult;
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        searchResult =
                            _navigateToSearchInputPage(isKeywordSearch: false);
                        filteredSearchResult = searchResult;
                        unfilteredSearchResult = searchResult;
                      },
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.07,
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _addressController.text.isNotEmpty
                                    ? _addressController.text
                                    : 'Gdzie?',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                            ),
                            if (_addressController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _addressController.text = '';
                                  });
                                  searchResult = _onTapSearch();
                                  filteredSearchResult = searchResult;
                                  unfilteredSearchResult = searchResult;
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.07,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(8),
                        value: _selectedDistance,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDistance = newValue!;
                            searchResult = _onTapSearch();
                            filteredSearchResult = searchResult;
                            unfilteredSearchResult = searchResult;
                          });
                        },
                        items: _distanceOptions.map((distance) {
                          return DropdownMenuItem<String>(
                            value: distance,
                            child: Text('$distance km'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              showFilters(),
              const SizedBox(height: 16),
              Expanded(
                child: SalonSearchList(
                  salonsSearchFuture: searchResult,
                  isDistanceNeeded: _isDistanceNeeded,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SalonCategoriesList showFilters() {
    return SalonCategoriesList(
      salonsFuture: searchResult,
      unfilteredSalonsFuture: unfilteredSearchResult,
      onCategorySelected: (category) {
        if (selectedCategories[category] == true) {
          // User tapped the same category again, show all results
          selectedCategory = null;
          searchResult = unfilteredSearchResult;
          setState(() {
            selectedCategories[category] = false;
          });
        } else {
          // User selected a new category, filter results
          selectedCategory = category;
          searchResult = _filterSearchResultsByCategory(category);
          setState(() {
            // Unselect all categories
            selectedCategories.updateAll((key, value) => false);
            // Select the tapped one
            selectedCategories[category] = true;
          });
        }
      },
    );
  }

  Future<List<SalonModel>> _filterSearchResultsByCategory(String category) {
    return searchResult.then((salons) {
      return salons
          .where((salon) => salon.flutterCategory == category)
          .toList();
    });
  }

  Future<List<SalonModel>> _navigateToSearchInputPage(
      {required bool isKeywordSearch}) async {
    final searchParams = await Get.to<SearchParameters>(
      () => SearchFieldScreen(isKeywordSearch: isKeywordSearch),
    );

    if (searchParams != null) {
      String? keywords;
      String? address;
      String? radius;

      if (!isKeywordSearch) {
        address = searchParams.address;
        radius = searchParams.radius ?? '2';
        keywords = _keywordController.text;
        setState(() {
          _isDistanceNeeded = true;
          _addressController.text = address ?? '';
          _selectedDistance = radius!;
        });
      } else {
        address = _addressController.text;
        radius = _selectedDistance;
        keywords = searchParams.keywords;
        setState(() {
          _isDistanceNeeded = false;
          _keywordController.text = keywords ?? '';
        });
      }

      if (keywords != "" && address != "") {
        if (widget.optionalCategry != '') {
          return fetchSearchSalons(http.Client(),
              keywords: keywords,
              address: address,
              radius: radius,
              category: widget.optionalCategry);
        }
        // Send the API request with both keywords and address
        return fetchSearchSalons(http.Client(),
            keywords: keywords, address: address, radius: radius);
      } else if (keywords != "") {
        if (widget.optionalCategry != '') {
          return fetchSearchSalons(http.Client(),
              keywords: keywords, category: widget.optionalCategry);
        }
        // Send the API request with keywords only
        return fetchSearchSalons(http.Client(), keywords: keywords);
      } else if (address != "") {
        if (widget.optionalCategry != '') {
          return fetchSearchSalons(http.Client(),
              address: address,
              radius: radius,
              category: widget.optionalCategry);
        }
        // Send the API request with address only
        return fetchSearchSalons(http.Client(),
            address: address, radius: radius);
      } else {
        // Return an empty list if both keywords and address are null
        return fetchSearchSalons(http.Client(),
            category: widget.optionalCategry);
      }
    } else {
      // Return an empty list if searchParams is null
      return [];
    }
  }

  Future<List<SalonModel>> _onTapSearch() {
    final keywords = _keywordController.text;
    final address = _addressController.text;
    final radius = _selectedDistance;
    _isDistanceNeeded = false;

    if (keywords.isNotEmpty) {
      if (address.isNotEmpty) {
        setState(() {
          _isDistanceNeeded = true;
        });
        // Send the API request with both keywords and address
        if (widget.optionalCategry != '') {
          return fetchSearchSalons(http.Client(),
              keywords: keywords,
              address: address,
              radius: radius,
              category: widget.optionalCategry);
        }
        return fetchSearchSalons(http.Client(),
            keywords: keywords, address: address, radius: radius);
      } else {
        setState(() {
          _isDistanceNeeded = false;
        });
        // Send the API request with keywords only
        if (widget.optionalCategry != '') {
          return fetchSearchSalons(http.Client(),
              keywords: keywords, category: widget.optionalCategry);
        }
        return fetchSearchSalons(
          http.Client(),
          keywords: keywords,
        );
      }
    } else if (address.isNotEmpty) {
      setState(() {
        _isDistanceNeeded = true;
      });
      // Send the API request with address only
      if (widget.optionalCategry != '') {
        return fetchSearchSalons(http.Client(),
            address: address, radius: radius, category: widget.optionalCategry);
      }
      return fetchSearchSalons(http.Client(), address: address, radius: radius);
    } else {
      // Both keywords and address are empty, return an empty list
      return Future.value([]);
    }
  }
}

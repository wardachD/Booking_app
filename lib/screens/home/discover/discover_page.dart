import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/discover/widgets/salon_categories_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'input_screen/search_field_screen.dart';
import 'widgets/salon_search_list.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

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
          color: Colors.grey[200],
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              : 'search',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
                            const Icon(Icons.location_pin),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _addressController.text.isNotEmpty
                                    ? _addressController.text
                                    : 'city',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
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
          unfilteredSearchResult = unfilteredSearchResult;
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
          _addressController.text = address ?? '';
          _selectedDistance = radius!;
        });
      } else {
        address = _addressController.text;
        radius = _selectedDistance;
        keywords = searchParams.keywords;
        setState(() {
          _keywordController.text = keywords ?? '';
        });
      }

      if (keywords != "" && address != "") {
        // Send the API request with both keywords and address
        return fetchSearchSalons(http.Client(),
                keywords: keywords, address: address, radius: radius)
            .catchError((error) {
          // Handle error in API request
          // For example, show an error message
          // Return an empty list in case of an error
          return [];
        });
      } else if (keywords != "") {
        // Send the API request with keywords only
        return fetchSearchSalons(http.Client(), keywords: keywords)
            .catchError((error) {
          // Handle error in API request
          // For example, show an error message
          // Return an empty list in case of an error
          return [];
        });
      } else if (address != "") {
        // Send the API request with address only
        return fetchSearchSalons(http.Client(),
                address: address, radius: radius)
            .catchError((error) {
          // Handle error in API request
          // For example, show an error message
          // Return an empty list in case of an error
          return [];
        });
      } else {
        // Return an empty list if both keywords and address are null
        return fetchSearchSalons(http.Client());
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

    if (keywords.isNotEmpty) {
      if (address.isNotEmpty) {
        // Send the API request with both keywords and address
        return fetchSearchSalons(http.Client(),
                keywords: keywords, address: address, radius: radius)
            .catchError((error) {
          // Handle error in API request
          // For example, show an error message or return an empty list
          return [];
        });
      } else {
        // Send the API request with keywords only
        return fetchSearchSalons(
          http.Client(),
          keywords: keywords,
        ).catchError((error) {
          // Handle error in API request
          // For example, show an error message or return an empty list
          return [];
        });
      }
    } else if (address.isNotEmpty) {
      // Send the API request with address only
      return fetchSearchSalons(http.Client(), address: address, radius: radius)
          .catchError((error) {
        // Handle error in API request
        // For example, show an error message or return an empty list
        return [];
      });
    } else {
      // Both keywords and address are empty, return an empty list
      return Future.value([]);
    }
  }
}

class SalonModel {
  final int id;
  final String name;
  final String addressCity;
  final String addressPostalCode;
  final String addressStreet;
  final String addressNumber;
  final String location;
  final String about;
  final String avatar;
  final String phoneNumber;
  final num distanceFromQuery;
  final int errorCode;
  final String flutterCategory;
  final List<Categories> categories;

  const SalonModel({
    required this.id,
    required this.name,
    required this.addressCity,
    required this.addressPostalCode,
    required this.addressStreet,
    required this.addressNumber,
    required this.location,
    required this.about,
    required this.avatar,
    required this.phoneNumber,
    required this.distanceFromQuery,
    required this.errorCode,
    required this.flutterCategory,
    required this.categories,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) {
    return SalonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      addressCity: json['address_city'] as String,
      addressPostalCode: json['address_postal_code'] as String,
      addressStreet: json['address_street'] as String,
      addressNumber: json['address_number'] as String,
      location: json['location'] as String,
      about: json['about'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phone_number'] as String,
      distanceFromQuery: json['distance_from_query'] as num,
      errorCode: json['error_code'] as int,
      flutterCategory: json['flutter_category'] as String,
      categories: List<Categories>.from((json['categories'] as List)
          .map((categories) => Categories.fromJson(categories))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address_city'] = addressCity;
    data['address_postal_code'] = addressPostalCode;
    data['address_street'] = addressStreet;
    data['address_number'] = addressNumber;
    data['location'] = location;
    data['about'] = about;
    data['avatar'] = avatar;
    data['phone_number'] = phoneNumber;
    data['distance_from_query'] = distanceFromQuery;
    data['error_code'] = errorCode;
    data['flutter_category'] = flutterCategory;
    data['categories'] = categories.map((v) => v.toJson()).toList();
    return data;
  }
}

class Categories {
  final int id;
  final int salon;
  final String name;
  final List<Services> services;

  Categories(
      {required this.id,
      required this.salon,
      required this.name,
      required this.services});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'] as int,
      salon: json['salon'] as int,
      name: json['name'] as String,
      services: List<Services>.from((json['services'] as List)
          .map((service) => Services.fromJson(service))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon'] = salon;
    data['name'] = name;
    data['services'] = services.map((v) => v.toJson()).toList();
    return data;
  }
}

class Services {
  final int id;
  final int salon;
  final int category;
  final String title;
  final String description;
  final String price;
  final int durationMinutes;

  Services(
      {required this.id,
      required this.salon,
      required this.category,
      required this.title,
      required this.description,
      required this.price,
      required this.durationMinutes});

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
        id: json['id'] as int,
        salon: json['salon'] as int,
        category: json['category'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        price: json['price'] as String,
        durationMinutes: json['duration_minutes'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon'] = salon;
    data['category'] = category;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['duration_minutes'] = durationMinutes;
    return data;
  }
}

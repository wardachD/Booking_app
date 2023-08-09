import 'package:findovio/models/salon_reviews_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';

Future<List<SalonModel>> fetchSalons(http.Client client) async {
  final response = await client.get(Uri.parse(Consts.dbApiGetAll));
  final responseBody = utf8.decode(response.bodyBytes);
  return compute(parseSalons,
      responseBody); // Używamy compute, aby uruchomić parsePhotos w osobnym izolacie.
}

Future<List<SalonModel>> fetchSearchSalons(http.Client client,
    {String? keywords, String? address, String? radius}) async {
  String query = '';

  if (keywords != null) {
    keywords = keywords.replaceAll(' ', '%20');
    query += 'keywords=$keywords';
  }

  if (radius != null) {
    var helper = int.parse(radius) * 1000;
    radius = helper.toString();
  }

  if (address != null) {
    address = address.replaceAll(' ', '%20');
    if (query.isNotEmpty) {
      query += '&';
    }
    query += 'address=$address&radius=$radius';
  }

  final response = await client.get(Uri.parse('${Consts.dbApiSearch}$query'));
  final responseBody = utf8.decode(response.bodyBytes);
  return compute(parseSalons, responseBody);
}

List<SalonModel> parseSalons(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<SalonModel>((json) => SalonModel.fromJson(json)).toList();
}

Future<List<Review>> fetchReviews(int salonId) async {
  final response = await http
      .get(Uri.parse('${Consts.dbApiGetReviews}$salonId/reviews/?format=json'));

  if (response.statusCode == 200) {
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    return List<Review>.from(l.map((model) => Review.fromJson(model)));
  } else {
    throw Exception('Failed to load reviews');
  }
}

Future<String> getPhoto(String? imageUrl) async {
  if (imageUrl == null) return '';
  final image = CachedNetworkImageProvider(imageUrl);
  return image.url;
}

Future<List<SalonSchedule>> fetchSalonSchedules(
    http.Client client, int salonId) async {
  final response = await client.get(Uri.parse(
      'http://185.180.204.182:8000/api/generatedtimeslots/?format=json&salon=$salonId'));
  if (response.statusCode == 200) {
    String responseBody = utf8.decode(response.bodyBytes);
    return compute(parseSchedules, responseBody);
  } else {
    throw Exception('Failed to load schedules from API');
  }
}

List<SalonSchedule> parseSchedules(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SalonSchedule>((json) => SalonSchedule.fromJson(json))
      .toList();
}

Future<List<SalonWorkingHours>> fetchSalonWorkingHours(
    http.Client client, int salonId) async {
  final response = await client.get(Uri.parse(
      'http://185.180.204.182:8000/api/fixed-operating-hours/?format=json&salon=$salonId'));
  return compute(parseWorkingHours, utf8.decode(response.bodyBytes));
}

List<SalonWorkingHours> parseWorkingHours(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SalonWorkingHours>((json) => SalonWorkingHours.fromJson(json))
      .toList();
}

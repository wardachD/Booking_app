import 'dart:async';

import 'package:findovio/models/advertisement_model.dart';
import 'package:findovio/models/discover_page_keywords_list.dart';
import 'package:findovio/models/findovio_advertisement_model.dart';
import 'package:findovio/models/firebase_py_get_model.dart';
import 'package:findovio/models/firebase_py_register_model.dart';
import 'package:findovio/models/salon_reviews_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

InternetStatus? _connectionStatus;
late StreamSubscription<InternetStatus> _subscription;

void checkInternetConnection() {
  _subscription = InternetConnection().onStatusChange.listen((status) {
    _connectionStatus = status;
  });
}

void cancelInternetConnectionCheck() {
  _subscription.cancel();
}

Future<FindovioAdvertisement> fetchFindovioAdvertisement(
    http.Client client) async {
  try {
    bool isConnected = await InternetConnection().hasInternetAccess;

    if (isConnected) {
      final response =
          await client.get(Uri.parse(Consts.dbApiGetFindovioAdvertisement));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        return parseFindovioAdvertisement(responseBody);
      } else {
        // Obsługa błędu HTTP
        throw Exception('Nie można pobrać danych: ${response.statusCode}');
      }
    } else {
      // Brak połączenia z internetem - zwróć odpowiedni komunikat lub podejmij działania
      throw Exception('Brak połączenia z internetem');
    }
  } catch (e) {
    // Obsłuż błąd związany z zapytaniem
    return FindovioAdvertisement(
        id: 0,
        forceVisibility: false,
        url: '',
        title: '',
        content: ''); // Zwróć pusty obiekt w przypadku błędu
  }
}

FindovioAdvertisement parseFindovioAdvertisement(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return FindovioAdvertisement.fromJson(parsed);
}

Future<List<SalonModel>> fetchSalons(http.Client client) async {
  try {
    bool isConnected = await InternetConnection().hasInternetAccess;

    if (isConnected) {
      final response = await client.get(Uri.parse(Consts.dbApiGetAll));
      final responseBody = utf8.decode(response.bodyBytes);
      return compute(parseSalons, responseBody);
    } else {
      // Brak połączenia z internetem - zwróć odpowiedni komunikat lub podejmij działania
      throw Exception('Brak połączenia z internetem');
    }
  } catch (e) {
    // Obsłuż błąd związany z zapytaniem
    return []; // Return an empty list in case of error
  }
}

Future<List<DiscoverPageKeywordsList>> fetchKeywordsList(
    http.Client client) async {
  try {
    final url = Consts.dbApiGetKeywordsList;
    final response = await client.get(Uri.parse(url));
    final responseBody = utf8.decode(response.bodyBytes);
    return compute(parseKeywordsList, responseBody);
  } catch (e) {
    return [];
  }
}

List<DiscoverPageKeywordsList> parseKeywordsList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<DiscoverPageKeywordsList>(
          (json) => DiscoverPageKeywordsList.fromJson(json))
      .toList();
}

Future<SalonModel> fetchOneSalons(http.Client client, int salonID) async {
  try {
    final response = await client
        .get(Uri.parse('${Consts.dbApiGetOne}$salonID/?format=json'));
    final responseBody = utf8.decode(response.bodyBytes);
    return compute(parseSalon, responseBody);
  } catch (e) {
    return Future.error(e); // Return an empty list in case of error
  }
}

Future<int> changeFirebasePyUser(
    http.Client client, String userNameToChange, String userUid) async {
  try {
    Map<String, dynamic> data = {"firebase_name": "$userNameToChange"};

    final response = await client.patch(
      Uri.parse('${Consts.dbApiChangeFirebaseUser}$userUid/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    return response.statusCode;
  } catch (e) {
    // Jeśli wystąpi błąd, nadal zwracamy pustego użytkownika, ale nie przerywamy działania aplikacji
    return 0; // Może musisz dostosować to do swojego modelu FirebasePyGetModel
  }
}

Future<FirebasePyGetModel> fetchFirebasePyUser(
    http.Client client, String userUid) async {
  try {
    final response = await client.get(
        Uri.parse('${Consts.dbApiGetFirebaseUserByUid}$userUid/?format=json'));
    final responseBody = utf8.decode(response.bodyBytes);
    final user = parseFirebasePyUser(responseBody);

    return user;
  } catch (e) {
    // Jeśli wystąpi błąd, nadal zwracamy pustego użytkownika, ale nie przerywamy działania aplikacji
    return Future
        .value(); // Może musisz dostosować to do swojego modelu FirebasePyGetModel
  }
}

FirebasePyGetModel parseFirebasePyUser(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return FirebasePyGetModel.fromJson(parsed);
}

Future<List<SalonModel>> fetchSearchSalons(http.Client client,
    {String? keywords,
    String? address,
    String? radius,
    String? category}) async {
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
  if (category != null) {
    if (query.isNotEmpty) {
      query += '&';
    }
    query += 'category=$category';
  }

  final response = await client.get(Uri.parse('${Consts.dbApiSearch}$query'));
  final responseBody = utf8.decode(response.bodyBytes);
  print(responseBody.toString());
  return compute(parseSalons, responseBody);
}

SalonModel parseSalon(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return SalonModel.fromJson(parsed);
}

List<SalonModel> parseSalons(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<SalonModel>((json) => SalonModel.fromJson(json)).toList();
}

FirebasePyRegisterModel parseRegister(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return FirebasePyRegisterModel.fromJson(parsed);
}

Future<String> sendPostRegisterRequest(
    FirebasePyRegisterModel userModel) async {
  final url = Uri.parse(Consts.dbApiRegisterFirebaseUser);
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final dataToSend = userModel.toJson();
  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(dataToSend),
  );

  if (response.statusCode == 201) {
    return 'success';
  }
  if (response.statusCode == 400) {
    return 'bad_request';
  } else {
    return 'no_connection';
  }
}

Future<String> sendStatusUpdate(
    int appointmentID, String appointmentStatus) async {
  try {
    var response = await http.put(
      Uri.parse(Consts.dbApiSendStatusChange(appointmentID, appointmentStatus)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      return response.statusCode.toString();
    }
  } catch (e) {
    return e.toString();
    // Handle any exceptions
  }
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

Future<List<Advertisement>> fetchAllAdvertisements(http.Client client) async {
  final response =
      await client.get(Uri.parse(Consts.dbApiGetAllAdvertisements));
  return compute(parseAdvertisements, utf8.decode(response.bodyBytes));
}

List<Advertisement> parseAdvertisements(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Advertisement>((json) => Advertisement.fromJson(json))
      .toList();
}

Future<String> sendPostRequest(Map<String, dynamic> dataToSend) async {
  final url = Uri.parse(Consts.dbApiPostBooking);
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(dataToSend), // Use the provided data as the body
  );

  if (response.statusCode == 201) {
    return 'success';
  }
  if (response.statusCode == 400) {
    return 'bad_request';
  } else {
    return 'no_connection';
  }
}

Future<String> sendPostReviewRequest(Map<String, dynamic> dataToSend) async {
  final url = Uri.parse(Consts.dbApiPostReview);
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(dataToSend), // Use the provided data as the body
  );

  if (response.statusCode == 201) {
    return 'success';
  }
  if (response.body.contains('notunique')) {
    return 'not unique';
  }
  if (response.statusCode == 400) {
    return 'bad_request';
  } else {
    return 'no_connection';
  }
}

Future<List<UserAppointment>> fetchAppointments(
    http.Client client, String userId) async {
  try {
    final response =
        await client.get(Uri.parse('${Consts.dbApiGetUserBookings}$userId'));

    if (response.statusCode == 200) {
      return compute(parseUserAppointment, utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load appointments');
    }
  } catch (e) {
    return []; // Return an empty list in case of error
  }
}

List<UserAppointment> parseUserAppointment(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<UserAppointment>((json) => UserAppointment.fromJson(json))
      .toList();
}

class FetchSalonServiceException implements Exception {
  final String message;
  FetchSalonServiceException(this.message);
}

Future<Services> fetchSalonService(http.Client client, int service) async {
  try {
    final response = await client
        .get(Uri.parse('${Consts.dbApiGetSalonService}$service/?format=json'));

    if (response.statusCode == 200) {
      return compute(parseSalonService, utf8.decode(response.bodyBytes));
    } else {
      throw FetchSalonServiceException('Failed to load appointments');
    }
  } catch (e) {
    throw FetchSalonServiceException('Error fetching appointments');
  }
}

Services parseSalonService(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Services>((json) => Services.fromJson(json)).toList();
}

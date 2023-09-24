import 'package:findovio/models/salon_schedule.dart';

import 'salon_model.dart';

class UserAppointment {
  final int id;
  final int salon;
  final String salonName;
  final String customer;
  final String dateOfBooking;
  final List<Services> services;
  final String totalAmount;
  final String comment;
  final String status;
  final String createdAt;
  final List<SalonSchedule> timeslots;

  UserAppointment({
    required this.id,
    required this.salon,
    required this.salonName,
    required this.customer,
    required this.dateOfBooking,
    required this.services,
    required this.totalAmount,
    required this.comment,
    required this.status,
    required this.createdAt,
    required this.timeslots,
  });

  factory UserAppointment.fromJson(Map<String, dynamic> json) {
    return UserAppointment(
      id: json['id'],
      salon: json['salon'],
      salonName: json['salon_name'],
      customer: json['customer'],
      dateOfBooking: json['date_of_booking'],
      services: List<Services>.from(
          json['services'].map((service) => Services.fromJson(service))),
      totalAmount: json['total_amount'],
      comment: json['comment'],
      status: json['status'],
      createdAt: json['created_at'],
      timeslots: List<SalonSchedule>.from(json['timeslots']
          .map((timeslots) => SalonSchedule.fromJson(timeslots))),
    );
  }
}

List<UserAppointment> parseAppointmentsList(List<dynamic> jsonList) {
  return jsonList.map((json) => UserAppointment.fromJson(json)).toList();
}

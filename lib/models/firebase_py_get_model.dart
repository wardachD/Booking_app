class FirebasePyGetModel {
  final int id;
  final String firebaseName;
  final String firebaseEmail;
  final String firebaseUid;
  final DateTime timestamp;
  final String? avatar;

  FirebasePyGetModel({
    required this.id,
    required this.firebaseName,
    required this.firebaseEmail,
    required this.firebaseUid,
    required this.timestamp,
    this.avatar,
  });

  factory FirebasePyGetModel.fromJson(Map<String, dynamic> json) {
    return FirebasePyGetModel(
      id: json['id'] as int,
      firebaseName: json['firebase_name'] as String,
      firebaseEmail: json['firebase_email'] as String,
      firebaseUid: json['firebase_uid'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_name': firebaseName,
      'firebase_email': firebaseEmail,
      'firebase_uid': firebaseUid,
      'timestamp': timestamp.toIso8601String(),
      'avatar': avatar,
    };
  }
}

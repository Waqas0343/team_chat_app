import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? fcmToken;
  final String? photoUrl;
  final DateTime? lastSignIn;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.fcmToken,
    this.photoUrl,
    this.lastSignIn,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    DateTime? parseLastSignIn(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return UserModel(
      id: id,
      email: data['email']?.toString() ?? '',
      displayName: data['displayName']?.toString() ?? '',
      fcmToken: data['fcmToken']?.toString(),
      photoUrl: data['photoUrl']?.toString(),
      lastSignIn: parseLastSignIn(data['lastSignIn']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'fcmToken': fcmToken,
      'photoUrl': photoUrl,
      'lastSignIn': lastSignIn != null ? Timestamp.fromDate(lastSignIn!) : null,
    };
  }
}

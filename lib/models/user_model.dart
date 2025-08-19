class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? fcmToken;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.fcmToken,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'],
      displayName: data['displayName'],
      fcmToken: data['fcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'fcmToken': fcmToken,
    };
  }
}
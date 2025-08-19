class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? fcmToken;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.fcmToken,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'],
      displayName: data['displayName'],
      fcmToken: data['fcmToken'],
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'fcmToken': fcmToken,
      'photoUrl': photoUrl,
    };
  }
}
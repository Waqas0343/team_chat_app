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
    return UserModel(
      id: id,
      email: data['email'],
      displayName: data['displayName'],
      fcmToken: data['fcmToken'],
      photoUrl: data['photoUrl'],
      lastSignIn: data['lastSignIn'] != null
          ? DateTime.tryParse(data['lastSignIn'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'fcmToken': fcmToken,
      'photoUrl': photoUrl,
      'lastSignIn': lastSignIn,
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName,
          'fcmToken': fcmToken,
        }, SetOptions(merge: true));
        return UserModel(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName ?? 'User',
          fcmToken: fcmToken,
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  User? getCurrentUser() => _auth.currentUser;
}
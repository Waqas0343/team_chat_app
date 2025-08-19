import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';
import 'package:team_chat_app/routes/app_routes.dart';
import '../../../models/user_model.dart';

class AuthScreenController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    signInWithGoogle();
  }
  Future<UserModel?> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Debug.log('Google Sign-In cancelled by user');
        isLoading.value = false;
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoURL,
          'fcmToken': fcmToken,
          'lastSignIn': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        final userModel = UserModel(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName ?? 'User',
          photoUrl: user.photoURL,
          fcmToken: fcmToken,
        );

        // Navigate to HomeScreen
        Get.offAllNamed(AppRoutes.homeScreen);
        isLoading.value = false;
        return userModel;
      }

      isLoading.value = false;
      return null;
    } catch (e) {
      Debug.log('Google Sign-In error: $e');
      isLoading.value = false;
      return null;
    }
  }
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Debug.log('User signed out successfully');
      Get.offAllNamed(AppRoutes.loginWithMail);
    } catch (e) {
      Debug.log('Error during sign-out: $e');
    }
  }

  User? getCurrentUser() => _auth.currentUser;
}

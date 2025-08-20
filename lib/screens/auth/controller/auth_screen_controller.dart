import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_chat_app/routes/app_routes.dart';
import '../../../models/user_model.dart';

class AuthScreenController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    checkAlreadySignedIn();
  }


  Future<void> checkAlreadySignedIn() async {
    final user = auth.currentUser;
    if (user != null) {
      isLoading.value = true;

      // Update FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await firestore.collection('users').doc(user.uid).set({
        'fcmToken': fcmToken,
        'lastSignIn': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      Get.offAllNamed(AppRoutes.homeScreen);
      isLoading.value = false;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await firestore.collection('users').doc(user.uid).set({
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

        Get.offAllNamed(AppRoutes.homeScreen);
        isLoading.value = false;
        return userModel;
      }

      isLoading.value = false;
      return null;
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
    Get.offAllNamed(AppRoutes.loginWithMail);
  }
}


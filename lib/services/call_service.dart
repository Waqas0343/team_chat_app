import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class CallService {
  static const String appId = 'YOUR_AGORA_APP_ID'; // Replace with your Agora App ID
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> startCall(String receiverId) async {
    if (await Permission.microphone.request().isGranted) {
      final callId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('calls').doc(callId).set({
        'callerId': FirebaseAuth.instance.currentUser!.uid,
        'receiverId': receiverId,
        'channelName': callId,
        'status': 'pending',
      });
      return callId;
    }
    return '';
  }

  Future<void> joinCall(String channelName, Function(int uid, String channel) onUserJoined) async {
    await AgoraRtcEngine.create(appId);
    await AgoraRtcEngine.enableAudio();
    await AgoraRtcEngine.joinChannel(null, channelName, null, 0);
    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      onUserJoined(uid, channelName);
    };
  }

  Future<void> endCall(String callId) async {
    await _firestore.collection('calls').doc(callId).update({'status': 'ended'});
    await AgoraRtcEngine.leaveChannel();
    await AgoraRtcEngine.destroy();
  }
}
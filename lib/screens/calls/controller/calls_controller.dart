import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' hide navigator;
import '../../../services/call_service.dart';

class CallController extends GetxController {
  final String callId;
  final bool isVideo;
  final CallService _callService = CallService();
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  var inCall = false.obs;
  var isMuted = false.obs;
  var isSpeakerOn = false.obs;
  var isVideoOn = true.obs;

  CallController({required this.callId, required this.isVideo});

  @override
  void onInit() {
    super.onInit();
    _initRenderers();
    _startOrJoinCall();
  }

  Future<void> _initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    if (isVideo) {
      // local camera stream bind kardo
      var stream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': true,
      });
      localRenderer.srcObject = stream;
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    // yahan audio track ka mute/unmute bhi handle karna hoga
  }

  void toggleSpeaker() {
    isSpeakerOn.value = !isSpeakerOn.value;
    // yahan speakerphone toggle logic add karo
  }

  void toggleVideo() {
    isVideoOn.value = !isVideoOn.value;
    // yahan video track ko enable/disable karo
  }

  Future<void> _startOrJoinCall() async {
    _callService.joinCall(callId, (stream) {
      remoteRenderer.srcObject = stream;
      inCall.value = true;
    });
  }

  Future<void> endCall() async {
    await _callService.endCall(callId);
    Get.back(); // Navigate back using GetX
  }

  @override
  void onClose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    _callService.endCall(callId);
    super.onClose();
  }
}


import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import '../../../services/call_service.dart';

class CallController extends GetxController {
   String? callId;
  final CallService _callService = CallService();
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  var inCall = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initRenderers();
    _startOrJoinCall();
  }

  Future<void> _initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> _startOrJoinCall() async {
    _callService.joinCall(callId!, (stream) {
      remoteRenderer.srcObject = stream;
      inCall.value = true;
    });
  }

  Future<void> endCall() async {
    await _callService.endCall(callId!);
    Get.back(); // Navigate back using GetX
  }

  @override
  void onClose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    _callService.endCall(callId!);
    super.onClose();
  }
}

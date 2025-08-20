import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'controller/calls_controller.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final CallController controller = Get.put(CallController());

    return Scaffold(
      appBar: AppBar(title: Text('Audio Call')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(controller.inCall.value ? 'Connected' : 'Calling...')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.endCall,
              child: Text('End Call'),
            ),
            SizedBox(height: 20),
            // Optional: show video renderers
            Container(
              width: 120,
              height: 160,
              child: RTCVideoView(controller.localRenderer),
            ),
            SizedBox(height: 10),
            Container(
              width: 240,
              height: 320,
              child: RTCVideoView(controller.remoteRenderer),
            ),
          ],
        ),
      ),
    );
  }
}

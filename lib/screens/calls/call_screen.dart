import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'controller/calls_controller.dart';

class CallScreen extends StatelessWidget {
  final String callId;
  final bool isVideo;
  final String userName;
  final String? userPhotoUrl;


  const CallScreen({
    super.key,
    required this.callId,
    required this.isVideo,
    required this.userName,
    this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final CallController controller = Get.put(CallController(callId: callId, isVideo: isVideo));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Background for Video Call
            if (isVideo)
              Obx(() => controller.inCall.value
                  ? RTCVideoView(
                controller.remoteRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              )
                  : Container(color: Colors.black87)),

            // 🔹 Overlay UI
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔹 Top user info
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userPhotoUrl != null
                            ? NetworkImage(userPhotoUrl!)
                            : const AssetImage("assets/images/avatar.png") as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        controller.inCall.value ? "Connected" : "Calling...",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      )),
                    ],
                  ),
                ),

                // 🔹 Local Video (small preview for video call)
                if (isVideo)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: RTCVideoView(controller.localRenderer),
                    ),
                  ),

                // 🔹 Call controls
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.mic_off,
                        color: Colors.grey.shade800,
                        onTap: controller.toggleMute,
                      ),
                      _buildActionButton(
                        icon: Icons.volume_up,
                        color: Colors.grey.shade800,
                        onTap: controller.toggleSpeaker,
                      ),
                      if (isVideo)
                        _buildActionButton(
                          icon: Icons.videocam_off,
                          color: Colors.grey.shade800,
                          onTap: controller.toggleVideo,
                        ),
                      _buildActionButton(
                        icon: Icons.call_end,
                        color: Colors.red,
                        onTap: controller.endCall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

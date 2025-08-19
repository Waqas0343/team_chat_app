import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/call_service.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  CallScreen({required this.callId});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallService _callService = CallService();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCall = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _startOrJoinCall();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startOrJoinCall() async {
    _callService.joinCall(widget.callId, (MediaStream stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
        _inCall = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Call')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_inCall ? 'Connected' : 'Calling...'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _callService.endCall(widget.callId);
                Navigator.pop(context);
              },
              child: Text('End Call'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _callService.endCall(widget.callId);
    super.dispose();
  }
}
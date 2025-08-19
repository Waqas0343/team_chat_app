import 'package:flutter/material.dart';
import '../services/call_service.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  CallScreen({required this.callId});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallService _callService = CallService();

  @override
  void initState() {
    super.initState();
    _callService.joinCall(widget.callId, (uid, channel) {
      setState(() {});
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
            Text('Calling...'),
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
    _callService.endCall(widget.callId);
    super.dispose();
  }
}
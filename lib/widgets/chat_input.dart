import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final Function(String, String) onSendMessage;
  final Future<String?> Function() onSendImage;
  final Future<String?> Function() onSendVoice;

  ChatInput({
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendVoice,
  });

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () async {
              final url = await onSendImage();
              if (url != null) onSendMessage(url, 'image');
            },
          ),
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () async {
              final url = await onSendVoice();
              if (url != null) onSendMessage(url, 'voice');
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Type a message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                onSendMessage(_controller.text, 'text');
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInput extends StatefulWidget {
  final Function(String, String) onSendMessage;
  final Future<String?> Function() onSendImage;
  final Future<String?> Function() onSendVoice;

  ChatInput({
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendVoice,
  });

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  var hasText = false.obs;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      hasText.value = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          // Image button
          IconButton(
            icon: Icon(Icons.image, color: Colors.grey[700]),
            onPressed: () async {
              final url = await widget.onSendImage();
              if (url != null) widget.onSendMessage(url, 'image');
            },
          ),
          // Expanded input field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 6),
          // Dynamic Send/Mic button
          Obx(() => Container(
            decoration: BoxDecoration(
              color: Color(0xFF023a84), // Primary color
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                hasText.value ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
              onPressed: () async {
                if (hasText.value) {
                  widget.onSendMessage(
                      _controller.text.trim(), 'text');
                  _controller.clear();
                } else {
                  final url = await widget.onSendVoice();
                  if (url != null) widget.onSendMessage(url, 'voice');
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}

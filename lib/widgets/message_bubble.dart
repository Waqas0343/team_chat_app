import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: message.type == 'text'
            ? Text(message.content)
            : message.type == 'image'
            ? Image.network(message.content, height: 200, width: 200)
            : ElevatedButton(
          onPressed: () async {
            final player = AudioPlayer();
            await player.play(UrlSource(message.content));
          },
          child: Text('Play Voice'),
        ),
      ),
    );
  }
}
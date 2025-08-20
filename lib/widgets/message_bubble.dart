import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_chat_app/app_styles/app_constant_file/app_colors.dart';
import '../models/message_model.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final bgColor = isMe ? Color(0xff4d71b5) : Color(0xFFFF9E4D);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.type == 'text')
                Text(
                  message.content,
                  style: Get.textTheme.titleSmall?.copyWith(
                      fontSize: 16,
                    color: Colors.white
                  )
                )
              else if (message.type == 'image')
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.content,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    final player = AudioPlayer();
                    await player.play(UrlSource(message.content));
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Voice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
               SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    message.timestamp != null
                        ? DateFormat('hh:mm a').format(message.timestamp!)
                        : '',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 2),
                  if (isMe)
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class CreateGroupScreen extends StatelessWidget {
  final TextEditingController _groupNameController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Group')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Example: Add current user and dummy members
                final groupId = await _chatService.createGroup(
                  _groupNameController.text,
                  ['user1', 'user2'], // Replace with actual user IDs
                );
                Navigator.pop(context);
              },
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
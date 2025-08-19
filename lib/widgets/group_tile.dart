import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final String groupId;
  final String groupName;
  final VoidCallback onTap;

  GroupTile({required this.groupId, required this.groupName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(groupName),
      onTap: onTap,
    );
  }
}
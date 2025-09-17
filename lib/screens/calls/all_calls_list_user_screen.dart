import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/all_calls_list_user_controller.dart';

class AllCallsListUserScreen extends StatelessWidget {
  const AllCallsListUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AllCallsListUserController  controller = Get.put(AllCallsListUserController());
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Calls")),
      body: Obx(() {
        if (controller.calls.isEmpty) {
          return const Center(child: Text("No calls yet"));
        }
        return ListView.builder(
          itemCount: controller.calls.length,
          itemBuilder: (context, index) {
            final call = controller.calls[index];

            return ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: call["userImage"] != ""
                    ? NetworkImage(call["userImage"])
                    : null,
                child: call["userImage"] == "" ? const Icon(Icons.person) : null,
              ),
              title: Text(call["userName"]),
              subtitle: Text(
                "${call["isVideo"] ? "Video Call" : "Audio Call"} • "
                    "${call["timestamp"].toString().substring(0, 16)}",
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Icon(
                call["isVideo"] ? Icons.videocam : Icons.call,
                color: call["isVideo"] ? Colors.blue : Colors.green,
              ),
            );
          },
        );
      }),
    );
  }
}


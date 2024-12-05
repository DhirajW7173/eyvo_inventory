import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static String route = "notification_screen";

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification page"),
        leading: IconButton(
          icon: Image.asset(ImageAssets.backButton, width: 18, height: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Card(
              child: SizedBox(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Title",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "${message.notification!.title}"),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Body",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "${message.notification!.body}"),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Payload",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "${message.data}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:chat_app/screens/home_screen/components/message_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 1; i <= 10; i++)
                MessageCard(
                  name: "John Doe",
                  imageUrl: "https://via.placeholder.com/150",
                  lastOnline: "$i hour ago",
                ),
            ],
          ),
        ),
      ),
    );
  }
}

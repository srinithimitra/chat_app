import 'package:chat_app/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/pages/home_page.dart';

import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  static const String id = "AuthGate";
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) =>
            snapshot.hasData ? const HomePage() : const RegisterPage(),
      ),
    );
  }
}

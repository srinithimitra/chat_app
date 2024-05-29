import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String id = "LoginPage";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Future<void> signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      var user = await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );

      logger.d(user);

      if (user.user != null) Navigator.pushNamed(context, HomePage.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey,
                ),
                const Text(
                  'Welcome Back! You were missed ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyButton(onTap: signIn, text: 'Sign In'),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            child: const RegisterPage(),
                            type: PageTransitionType.bottomToTopPop,
                            childCurrent: const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

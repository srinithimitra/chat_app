import 'package:chat_app/constants.dart';
import 'package:chat_app/controllers/auth.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/login_screen/animations/change_screen_animations.dart';
import 'package:chat_app/screens/login_screen/components/bottom_text.dart';
import 'package:chat_app/screens/login_screen/components/top_text.dart';
import 'package:chat_app/utils/helper_functions.dart';
import 'package:chat_app/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

enum Screens { createAccount, welcomeBack }

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late List<Widget> createAccountContent;
  late List<Widget> loginContent;
  Widget inputField(String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 36,
        vertical: 8,
      ),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: hint,
                prefixIcon: Icon(icon)),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    createAccountContent = [
      inputField("Name", Ionicons.person),
      inputField("Email", Ionicons.mail_outline),
      inputField("Password", Ionicons.lock_closed_outline),
      loginButton("Sign up"),
      orDivider(),
      logos(),
    ];

    loginContent = [
      inputField("Email", Ionicons.mail_outline),
      inputField("Password", Ionicons.lock_closed_outline),
      loginButton("Log In"),
      forgorPassword(),
    ];

    ChangeScreenAnimation.initalize(
        vsync: this,
        createAccountItems: createAccountContent.length,
        loginItems: loginContent.length);

    for (int i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctios.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }
    for (int i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctios.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 136,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              )
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        )
      ],
    );
  }

  Padding forgorPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 110,
      ),
      child: TextButton(
        onPressed: () {
          logger.i("Forgot Password");
        },
        child: const Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  Padding logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Image.asset("assets/images/facebook.png"),
            onTap: () {},
          ),
          const SizedBox(
            width: 24,
          ),
          GestureDetector(
            child: Image.asset("assets/images/google.png"),
            onTap: () {
              logger.i("Google Sign In");
              AuthController().signUpWithGoogle();
            },
          ),
        ],
      ),
    );
  }

  Padding orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "or",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Padding loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 135,
        vertical: 16,
      ),
      child: ElevatedButton(
        onPressed: () async {
          UserModel user = UserModel(
            username: "sappy",
            email: "sappy@sappy.com",
          );
          logger.i("Login ${user.username}");
          await AuthController()
              .signUpWithEmailandPassword(user: user, password: "sappy@1234");
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          elevation: 8,
          backgroundColor: kSecondaryColor,
          foregroundColor: Colors.white,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

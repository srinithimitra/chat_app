import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/login_screen/animations/change_screen_animations.dart';
import 'package:chat_app/screens/login_screen/components/login_content.dart';
import 'package:chat_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';


class BottomText extends StatefulWidget {
  const BottomText({
    super.key,
  });

  @override
  State<BottomText> createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {
  @override
  void initState() {
    ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctios.wrapWithAnimatedBuilder(
      animation: ChangeScreenAnimation.bottomTextAnimation,
      child: GestureDetector(
        onTap: () {
          if (!ChangeScreenAnimation.isPlaying) {
            ChangeScreenAnimation.currentScreen == Screens.createAccount
                ? ChangeScreenAnimation.forward()
                : ChangeScreenAnimation.reserve();

            ChangeScreenAnimation.currentScreen =
                Screens.values[1 - ChangeScreenAnimation.currentScreen.index];
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "Montserrat",
              ),
              children: [
                TextSpan(
                  text: ChangeScreenAnimation.currentScreen ==
                          Screens.createAccount
                      ? "Already have an account?"
                      : "Don't have an account?",
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ChangeScreenAnimation.currentScreen ==
                          Screens.createAccount
                      ? "Log In"
                      : "Sign Up",
                  style: const TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

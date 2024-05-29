import 'package:flutter/material.dart';
import 'package:chat_app/screens/login_screen/animations/change_screen_animations.dart';
import 'package:chat_app/screens/login_screen/components/login_content.dart';
import 'package:chat_app/utils/helper_functions.dart';

class TopText extends StatefulWidget {
  const TopText({
    super.key,
  });

  @override
  State<TopText> createState() => _TopTextState();
}

class _TopTextState extends State<TopText> {
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
      animation: ChangeScreenAnimation.topTextAnimation,
      child: Text(
        ChangeScreenAnimation.currentScreen == Screens.createAccount
            ? 'Create\nAccount'
            : 'Welcome\nBack',
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

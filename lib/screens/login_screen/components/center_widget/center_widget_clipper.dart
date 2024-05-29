import 'package:flutter/material.dart';

class CenterWidgetClipper extends CustomClipper<Path> {
  final Path path;

  const CenterWidgetClipper({required this.path});

  @override
  getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

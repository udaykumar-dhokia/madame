import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madame/auth/auth.dart';
import 'package:madame/constants/colors.dart';
import 'package:madame/utils/screen_size.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Auth(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  "lib/assets/taxi.png",
                  width: screenSize.width * 0.5, // Adjust width as needed
                  height: screenSize.height * 0.3, // Adjust height as needed
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: const [
                        primaryDark,
                        Colors.pink,
                        Color(0xffffb3c1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      transform: GradientRotation(
                          _controller.value * 2 * 3.14159), // Single rotation
                    ).createShader(bounds);
                  },
                  child: Text(
                    "madame",
                    style: GoogleFonts.manrope(
                      fontSize: screenSize.widthPercentage(8),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "A safer way to go.",
                  style: GoogleFonts.manrope(
                    fontSize: screenSize.widthPercentage(3.5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

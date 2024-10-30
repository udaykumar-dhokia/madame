import 'dart:ui'; // Import this for ImageFilter

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madame/constants/colors.dart';
import 'package:madame/utils/screen_size.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

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
      body: Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: primary.withOpacity(1),
            ),
          ),
          Opacity(
            opacity: 0.4,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  "lib/assets/taxi.png",
                  width: screenSize.width * 0.5,
                  height: screenSize.height * 0.3,
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
                        Color.fromARGB(255, 233, 110, 151),
                        Color(0xffffb3c1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      transform:
                          GradientRotation(_controller.value * 2 * 3.14159),
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

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madame/auth/login.dart';
import 'package:madame/components/loading.dart';
import 'package:madame/constants/colors.dart';
import 'package:madame/screens/homepage/homepage.dart';
import 'package:madame/utils/screen_size.dart';
import 'package:toastification/toastification.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  bool isObcsure = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
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

  void signUp(final data) async {
    try {
      setState(() {
        isLoading = true;
      });
      final credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(data["email"])
          .set(data);

      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: Text(
          'Sign Up successfully',
          style: GoogleFonts.manrope(),
        ),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Homepage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(
          'Something went wrong.',
          style: GoogleFonts.manrope(),
        ),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);
    return isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              surfaceTintColor: transparent,
              toolbarHeight: screenSize.heightPercentage(15),
              backgroundColor: primary,
              title: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          transform: GradientRotation(_controller.value *
                              2 *
                              3.14159), // Single rotation
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
                if (isLoading)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        height: screenSize.heightPercentage(15),
                        width: screenSize.width,
                        color: primary.withOpacity(0.2),
                      ),
                    ),
                  ),
              ]),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!isLoading)
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.manrope(color: black),
                    ),
                  if (!isLoading)
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Login(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.manrope(color: primaryDark),
                      ),
                    ),
                ],
              ),
            ),
            backgroundColor: primary,
            body: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Image.asset(
                            'lib/assets/taxi.png', // Replace with your image path
                            width: screenSize.widthPercentage(30),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          "Register yourself.",
                          style: GoogleFonts.manrope(
                              fontSize: screenSize.widthPercentage(13),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _name,
                          style: GoogleFonts.manrope(),
                          cursorColor: black,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: primaryDark),
                            ),
                            labelText: "Name",
                            labelStyle: GoogleFonts.manrope(color: black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _mobile,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: GoogleFonts.manrope(),
                          cursorColor: black,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: primaryDark),
                            ),
                            prefixText: "+91 ",
                            labelText: "Mobile",
                            labelStyle: GoogleFonts.manrope(color: black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: grey),
                            ),
                            counterText: "",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _email,
                          style: GoogleFonts.manrope(),
                          cursorColor: black,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: primaryDark),
                            ),
                            labelText: "Email",
                            labelStyle: GoogleFonts.manrope(color: black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: isObcsure,
                          controller: _password,
                          style: GoogleFonts.manrope(),
                          cursorColor: black,
                          decoration: InputDecoration(
                            suffixIcon: isObcsure
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObcsure = false;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObcsure = true;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility_off),
                                  ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: primaryDark),
                            ),
                            labelText: "Password",
                            labelStyle: GoogleFonts.manrope(color: black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            if (_name.text.isEmpty ||
                                _email.text.isEmpty ||
                                _mobile.text.isEmpty ||
                                _password.text.isEmpty) {
                              toastification.show(
                                type: ToastificationType.error,
                                style: ToastificationStyle.fillColored,
                                context: context,
                                title: Text(
                                  'Please provide all required details',
                                  style: GoogleFonts.manrope(),
                                ),
                                autoCloseDuration: const Duration(seconds: 5),
                                alignment: Alignment.bottomCenter,
                              );
                            } else if (_mobile.text.isEmpty ||
                                _mobile.text.length != 10) {
                              toastification.show(
                                type: ToastificationType.error,
                                style: ToastificationStyle.fillColored,
                                context: context,
                                title: Text(
                                  'Please check your mobile number',
                                  style: GoogleFonts.manrope(),
                                ),
                                autoCloseDuration: const Duration(seconds: 5),
                                alignment: Alignment.bottomCenter,
                              );
                            } else {
                              final data = {
                                'name': _name.text,
                                'mobile': _mobile.text,
                                'email': _email.text,
                                'password': _password.text,
                                'rating': 0.0,
                                'created_at': DateTime.now().toUtc().toString(),
                              };
                              signUp(data);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 22,
                              right: 22,
                              top: 15,
                              bottom: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(210, 233, 30, 98),
                                primaryDark,
                              ]),
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.manrope(
                                    fontSize: screenSize.widthPercentage(4),
                                    color: white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Visibility(
                    visible: isLoading,
                    child: const Loader(),
                  ),
                ),
              ],
            ),
          );
  }
}

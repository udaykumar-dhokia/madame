import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madame/auth/signup.dart';
import 'package:madame/components/loading.dart';
import 'package:madame/constants/colors.dart';
import 'package:madame/screens/homepage/homepage.dart';
import 'package:madame/utils/screen_size.dart';
import 'package:toastification/toastification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isObcsure = true;

  void login(String email, String password) {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
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
  void initState() {
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);
    return isLoading
        ? const Loader()
        : Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.manrope(color: black),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Signup(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.manrope(color: primaryDark),
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              toolbarHeight: screenSize.heightPercentage(15),
              backgroundColor: primary,
              title: Column(
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
                    "A secure way to go.",
                    style: GoogleFonts.manrope(
                      fontSize: screenSize.widthPercentage(3.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: primary,
            body: Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              // height: screenSize.heightPercentage(85),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome back.",
                        style: GoogleFonts.manrope(
                            fontSize: screenSize.widthPercentage(13),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
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
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _password,
                        obscureText: isObcsure,
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
                                  icon: Icon(Icons.visibility),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isObcsure = true;
                                    });
                                  },
                                  icon: Icon(Icons.visibility_off),
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
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          if (_email.text.isEmpty || _password.text.isEmpty) {
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
                          } else {
                            login(_email.text, _password.text);
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
                              "Login",
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
            ),
          );
  }
}

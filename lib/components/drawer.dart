import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madame/constants/colors.dart';
import 'package:madame/utils/screen_size.dart';

class DrawerWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  const DrawerWidget({Key? key, required this.userData}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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

    return Drawer(
      width: screenSize.widthPercentage(80),
      backgroundColor: primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  "A safer way to go.",
                  style: GoogleFonts.manrope(
                    fontSize: screenSize.widthPercentage(3.5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Boxicons.bx_user,
                size: 20,
              ),
            ),
            title: Text(
              widget.userData["name"],
              style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.userData["mobile"],
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Boxicons.bxs_star,
                  color: warning,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.userData["rating"].toString(),
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            leading: const Icon(Boxicons.bx_history),
            title: Text(
              'My Rides',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Boxicons.bx_credit_card),
            title: Text(
              'Payments',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Boxicons.bx_check_shield),
            title: Text(
              'Safety',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Boxicons.bx_gift),
            title: Text(
              'Gifts',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Boxicons.bx_bell),
            title: Text(
              'Updates',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Boxicons.bx_cog),
            title: Text(
              'Settings',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Boxicons.bx_log_out_circle),
            title: Text(
              'Logout',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#Ride Safely",
                    style: GoogleFonts.manrope(
                      fontSize: screenSize.widthPercentage(8),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Made with ',
                        style: GoogleFonts.manrope(
                          fontSize: screenSize.widthPercentage(3.5),
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Boxicons.bxs_heart,
                        color: primaryDark,
                      ),
                      Text(
                        ' in India',
                        style: GoogleFonts.manrope(
                          fontSize: screenSize.widthPercentage(3.5),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

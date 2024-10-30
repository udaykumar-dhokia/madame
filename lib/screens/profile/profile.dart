import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:madame/constants/colors.dart';
import 'package:madame/screens/homepage/homepage.dart';
import 'package:madame/utils/screen_size.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic> userData;
  const Profile({super.key, required this.userData});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    int total = 5;
    int given = widget.userData.length;
    double completed = total / given;

    final screenSize = ScreenSize(context);
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        toolbarHeight: screenSize.heightPercentage(10),
        backgroundColor: primary,
        automaticallyImplyLeading: false,
        surfaceTintColor: transparent,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homepage(),
                  ),
                );
              },
              enableFeedback: true,
              child: const Icon(
                Boxicons.bx_arrow_back,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Profile",
              style: GoogleFonts.manrope(
                fontSize: screenSize.widthPercentage(6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: secondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                enableFeedback: true,
                leading: CircularPercentIndicator(
                  radius: 25.0,
                  lineWidth: 4.0,
                  animation: true,
                  percent: completed,
                  center: const Icon(
                    Boxicons.bx_user,
                    size: 20,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: success,
                ),
                title: Text(
                  widget.userData["name"],
                  overflow: TextOverflow.ellipsis,
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
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 20, bottom: 15),
              child: Text(
                "Personal Details",
                style: GoogleFonts.manrope(
                  fontSize: screenSize.widthPercentage(6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            listItem(
              widget.userData["name"],
              "Name",
              Boxicons.bx_user,
              black,
              context,
            ),
            listItem(
              '+91 ${widget.userData["mobile"]}',
              "Contact",
              Boxicons.bx_phone,
              black,
              context,
            ),
            listItem(
              widget.userData["contact"] ?? "Input Required",
              "Alternative Contact",
              Boxicons.bxs_contact,
              widget.userData["contact"] == null ? error : black,
              context,
            ),
            listItem(
              widget.userData["email"],
              "Email",
              Boxicons.bx_envelope,
              black,
              context,
            ),
            listItem(
              widget.userData["dob"] ?? "Input Required",
              "Date of Birth",
              Boxicons.bx_cake,
              widget.userData["dob"] == null ? error : black,
              context,
            ),
            listItem(
              DateFormat('dd MMMM yyyy')
                  .format(DateTime.parse(widget.userData["created_at"])),
              "Joined",
              Boxicons.bx_user_check,
              black,
              context,
            ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#Safety First",
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
      ),
    );
  }

  void _openModelBottomSheet(
      BuildContext context, String title, String value, IconData icon) {
    TextEditingController val = TextEditingController(text: value);

    void updateDetail(String title, String value) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.email)
            .update(
          {title: value},
        );
        Navigator.pop(context);
        setState(() {});
      } catch (e) {
        Navigator.pop(context);
        setState(() {});
      }
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        final screenSize = ScreenSize(context);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            width: screenSize.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: screenSize.width * 0.2,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Edit $title",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: screenSize.widthPercentage(7),
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        enableFeedback: true,
                        icon: const Icon(Boxicons.bx_x),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: val,
                    onChanged: (newValue) {
                      val.text = newValue;
                    },
                    style: GoogleFonts.manrope(
                        fontSize: screenSize.width * 0.05,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(width: 1, color: primaryDark),
                      ),
                      prefixIcon: Icon(icon),
                      filled: true,
                      fillColor: primary,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(width: 1),
                      ),
                      hintText: "Enter your value here",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: screenSize.width * 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      updateDetail(
                        title == "Name"
                            ? "name"
                            : title == "Alternative Contact"
                                ? "contact"
                                : "dob",
                        val.text,
                      );
                    },
                    enableFeedback: true,
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      width: screenSize.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(210, 233, 30, 98),
                          primaryDark,
                        ]),
                      ),
                      child: Center(
                          child: Text(
                        "Save",
                        style: GoogleFonts.manrope(
                          color: white,
                          fontWeight: FontWeight.w500,
                          fontSize: screenSize.widthPercentage(4.5),
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget listItem(String value, String title, IconData icon, Color color,
      BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: title == "Email" || title == "Joined" || title == "Contact"
          ? null
          : InkWell(
              onTap: () {
                _openModelBottomSheet(
                  context,
                  title,
                  value,
                  title == "Name"
                      ? Boxicons.bx_user
                      : title == "Alternative Contact"
                          ? Boxicons.bxs_contact
                          : Boxicons.bx_calendar,
                );
                setState(() {});
              },
              child: const Icon(Boxicons.bx_chevron_right_circle),
            ),
    );
  }
}

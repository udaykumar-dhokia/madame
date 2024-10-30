import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madame/components/drawer.dart';
import 'package:madame/components/loading.dart';
import 'package:madame/constants/colors.dart';
import 'package:madame/utils/screen_size.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final MapController _mapController = MapController();
  TextEditingController search =
      TextEditingController(text: "Where are you going?");
  bool isLoading = false;
  final List<Marker> _markers = [];
  late geo.Position currentPosition;
  final double _currentZoom = 15.0;
  Map<String, dynamic>? userData;
  final Map<String, String> _mapTemplates = {
    "Light Map":
        "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
    "Satellite View":
        "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    "Classic Map": "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png"
  };
  final String _selectedTemplate = "Light Map";
  String currentRide = "B";

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final data = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .get();

      setState(() {
        userData = data.data() as Map<String, dynamic>;
      });

      geo.LocationPermission permission;

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      _markers.add(
        Marker(
          point: LatLng(position.latitude, position.longitude),
          width: 80.0,
          height: 80.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2.0),
                child: const Icon(
                  Icons.location_on,
                  color: primaryDark,
                  size: 30,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Your location",
                    style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: black),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      setState(() {
        currentPosition = position;
      });

      setState(() {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          _currentZoom,
        );
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);
    return SafeArea(
      child: isLoading
          ? const Loader()
          : Scaffold(
              backgroundColor: primary,
              drawer: isLoading ? null : DrawerWidget(userData: userData!),
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      minZoom: 12,
                      maxZoom: 100,
                      keepAlive: true,
                      backgroundColor: primary.withOpacity(0.2),
                      initialCenter: LatLng(
                          currentPosition.latitude, currentPosition.longitude),
                      initialZoom: _currentZoom,
                    ),
                    children: [
                      TileLayer(
                        tileDisplay: const TileDisplay.fadeIn(),
                        urlTemplate: _mapTemplates[_selectedTemplate]!,
                      ),
                      MarkerLayer(
                        rotate: true,
                        markers: _markers,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Material(
                      color: transparent,
                      child: AppBar(
                        surfaceTintColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        toolbarHeight: screenSize.heightPercentage(10),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(
                              builder: (BuildContext context) {
                                return InkWell(
                                  enableFeedback: true,
                                  splashColor: transparent,
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Boxicons.bx_menu,
                                      color: Colors.black54,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  style: GoogleFonts.manrope(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  controller: search,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Boxicons.bx_search_alt,
                                      color: Colors.black54,
                                    ),
                                    fillColor: primary,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenSize.heightPercentage(10),
                    right: 15,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      mini: true,
                      backgroundColor: primary,
                      onPressed: () {
                        _mapController.move(
                          LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          _currentZoom,
                        );
                      },
                      child: const Icon(
                        Boxicons.bx_current_location,
                        color: primaryDark,
                        size: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 15, right: 15),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(4, 0),
                              blurRadius: 8,
                            ),
                          ],
                          color: primary,
                          borderRadius: BorderRadius.circular(20)),
                      width: screenSize.width,
                      height: screenSize.heightPercentage(42),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Choose your ride.",
                                style: GoogleFonts.manrope(
                                  fontSize: screenSize.widthPercentage(7),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentRide = "B";
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              border: currentRide == "B"
                                                  ? Border.all()
                                                  : Border.all(
                                                      color: transparent,
                                                    ),
                                              color: currentRide == "B"
                                                  ? white.withOpacity(0.3)
                                                  : transparent,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    "lib/assets/motorcycle1.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Bike",
                                            style: GoogleFonts.manrope(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentRide = "R";
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              border: currentRide == "R"
                                                  ? Border.all()
                                                  : Border.all(
                                                      color: transparent,
                                                    ),
                                              color: currentRide == "R"
                                                  ? white.withOpacity(0.3)
                                                  : transparent,
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    "lib/assets/rickshaw1.png"),
                                                fit: BoxFit.contain,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Align(
                                              alignment: Alignment.bottomCenter,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Auto",
                                            style: GoogleFonts.manrope(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentRide = "C";
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: currentRide == "C"
                                                  ? Border.all()
                                                  : Border.all(
                                                      color: transparent,
                                                    ),
                                              color: currentRide == "C"
                                                  ? white.withOpacity(0.3)
                                                  : transparent,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    "lib/assets/cartaxi1.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Cab",
                                            style: GoogleFonts.manrope(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
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
                                  "Continue",
                                  style: GoogleFonts.manrope(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenSize.widthPercentage(4.5),
                                  ),
                                )),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "#Ride Safely",
                                        style: GoogleFonts.manrope(
                                          fontSize:
                                              screenSize.widthPercentage(8),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Made with ',
                                            style: GoogleFonts.manrope(
                                              fontSize: screenSize
                                                  .widthPercentage(3.5),
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
                                              fontSize: screenSize
                                                  .widthPercentage(3.5),
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
                      ),
                    ),
                  ),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
    );
  }
}

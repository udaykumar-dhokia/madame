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
  TextEditingController search = TextEditingController();
  bool isLoading = false;
  final List<Marker> _markers = [];
  late geo.Position currentPosition;
  final double _currentZoom = 13.0;
  Map<String, dynamic> userData = {};

  final Map<String, String> _mapTemplates = {
    "Light Map":
        "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
    "Satellite View":
        "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    "Classic Map": "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png"
  };

  final String _selectedTemplate = "Light Map";

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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    search.text = "Where are you going?";
    fetchUser();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
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
            const Expanded(
              child: Center(
                child: Text(
                  "Your location",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    setState(() {
      currentPosition = position;
      isLoading = false;
    });

    _mapController.move(
      LatLng(position.latitude, position.longitude),
      _currentZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);
    return SafeArea(
      child: isLoading
          ? const Loader()
          : Scaffold(
              backgroundColor: primary,
              drawer: DrawerWidget(
                userData: userData,
              ),
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
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
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: transparent,
                      toolbarHeight: screenSize.heightPercentage(12),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primary,
                                    ),
                                    child: const Icon(Boxicons.bx_menu_alt_left,
                                        color: Colors.black54),
                                  ));
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
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
                        ],
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
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
    );
  }
}

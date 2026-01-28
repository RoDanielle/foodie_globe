import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // REQUIRED
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';

class GlobeScreen extends StatefulWidget {
  const GlobeScreen({super.key});

  @override
  State<GlobeScreen> createState() => _GlobeScreenState();
}

class _GlobeScreenState extends State<GlobeScreen> {
  late FlutterEarthGlobeController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      isBackgroundFollowingSphereRotation: true,
      surface: const AssetImage('assets/images/2k_earth_daymap.jpg'),
      nightSurface: const AssetImage('assets/images/2k_earth_nightmap.jpg'),
      background: const AssetImage('assets/images/2k_stars_milky_way.jpg'),
      showAtmosphere: true,
      atmosphereColor: Colors.blueAccent,
      isDayNightCycleEnabled: true,
      dayNightBlendFactor: 0.15,
    );

    _controller.onLoaded = () {
      _controller.setUseRealTimeSunPosition(true);
    };
  }

  // Logic to convert Firestore data into Globe Points
  void _updateGlobePoints(List<QueryDocumentSnapshot> docs) {
    _controller.points.clear();
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      
      if (data['lat'] != null && data['lng'] != null) {
        _controller.addPoint(
          Point(
            id: doc.id, // Using the Firestore document ID
            coordinates: GlobeCoordinates(
              (data['lat'] as num).toDouble(),
              (data['lng'] as num).toDouble(),
            ),
            label: data['name'] ?? 'Restaurant',
            isLabelVisible: true,
            style: const PointStyle(
              color: Color(0xFFFFB703), 
              size: 2,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.8, -0.6),
            radius: 1.5,
            colors: [Color(0xFF1A1A2E), Color(0xFF05050A)],
          ),
        ),
        child: Stack(
          children: [
            // --- STREAMBUILDER LISTENS TO FIRESTORE ---
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('visits')
                  .snapshots(), // This is the "live" part
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Every time data changes, we update the controller's points
                  _updateGlobePoints(snapshot.data!.docs);
                }

                return Center(
                  child: FlutterEarthGlobe(
                    controller: _controller,
                    radius: 180,
                  ),
                );
              },
            ),

            // Back Button
            Positioned(
              top: 50,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "LIVE CLOUD SYNC ACTIVE",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 2.0,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
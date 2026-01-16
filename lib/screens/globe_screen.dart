import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
// ADD THESE TWO LINES - They contain the classes for Points and Styles
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import '../main.dart';

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

    // Initialize the controller with your Foodie Globe settings
    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      zoom: 0.5,
      surface: const AssetImage('assets/images/2k_earth_daymap.jpg'),
      nightSurface: const AssetImage('assets/images/2k_earth_nightmap.jpg'),
      background: const AssetImage('assets/images/2k_stars_milky_way.jpg'),
      showAtmosphere: true,
      atmosphereColor: Colors.blueAccent,
      isDayNightCycleEnabled: true,
    );

    // This callback fires once the globe is ready to receive data
    _controller.onLoaded = () {
      _loadRestaurantPins();
    };
  }

  void _loadRestaurantPins() {
    _controller.points.clear();

    for (var visit in mockVisits) {
      // Ensure we have valid coordinates before adding
      if (visit['lat'] != null && visit['lng'] != null) {
        _controller.addPoint(
          Point(
            id: visit['name'], // Using name as a unique identifier
            coordinates: GlobeCoordinates(
              (visit['lat'] as num).toDouble(),
              (visit['lng'] as num).toDouble(),
            ),
            label: visit['name'],
            isLabelVisible: true,
            style: const PointStyle(
              color: Color(0xFFFFB703), // Your signature yellow
              size: 6,
            ),
          ),
        );
      }
    }
    
    // Trigger a rebuild so the points appear immediately
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The main 3D Globe
          Center(
            child: FlutterEarthGlobe(
              controller: _controller,
              radius: 180, // Slightly larger radius for better label spacing
            ),
          ),

          // Back Button UI
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          
          // Small legend or instruction (Optional)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Your Global Food Journey",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 1.2,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
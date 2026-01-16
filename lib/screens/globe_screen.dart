import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart'; // Add this

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
      zoom: 0.5,
      surface: const AssetImage('assets/images/2k_earth_daymap.jpg'),
      nightSurface: const AssetImage('assets/images/2k_earth_nightmap.jpg'),
      background: const AssetImage('assets/images/2k_stars_milky_way.jpg'),
      showAtmosphere: true,
      atmosphereColor: Colors.blueAccent,
      isDayNightCycleEnabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: FlutterEarthGlobe(
              controller: _controller,
              radius: 160,
            ),
          ),

          // Back Button
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
        ],
      ),
    );
  }
}

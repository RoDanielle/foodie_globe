import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

// GLOBAL MOCK DATABASE
// Update your mockVisits in lib/main.dart
List<Map<String, dynamic>> mockVisits = [
  {
    'name': 'Sushi Zen',
    'location': 'Tokyo',
    'lat': 35.6762, 
    'lng': 139.6503,
    'cuisine': 'Japanese',
    'dishes': 'Omakase Set',
    'isFavorite': true,
  },
  {
    'name': 'La Dolce Vita',
    'location': 'Rome',
    'lat': 41.9028,
    'lng': 12.4964,
    'cuisine': 'Italian',
    'dishes': 'Pasta Carbonara',
    'isFavorite': false,
  },
];

void main() {
  runApp(const MyRestaurantApp());
}

class MyRestaurantApp extends StatelessWidget {
  const MyRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodieGlobe',
      theme: ThemeData(
        primaryColor: const Color(0xff3a57e8),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
    );
  }
}
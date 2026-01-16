import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/visit_card.dart';
import 'add_visit_screen.dart';
import 'globe_screen.dart';
import 'welcome_screen.dart'; // Ensure this is imported for the logout button
import '../main.dart'; // Import the global mockVisits list

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Function to refresh UI when returning from Add Screen
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: const Text(
          'Foodie Globe',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // FIX: The actions property MUST be inside the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: () {
              // This takes the user back to the Welcome Screen and prevents "backing" into the app
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 24),
            _buildStatsGrid(),
            const SizedBox(height: 32),
            const Text(
              "Recent Visits",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecentVisits(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Your Culinary ", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        Text("Journey", style: TextStyle(color: Color(0xFFFFB703), fontSize: 28, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              // Wait for the Add screen to close, then refresh
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVisitScreen()));
              _refresh();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add New Visit"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB703), foregroundColor: Colors.black),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobeScreen())),
            icon: const Icon(Icons.public),
            label: const Text("View Globe"),
            style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFFB703), side: const BorderSide(color: Color(0xFFFFB703))),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        StatCard(title: "Total Visits", value: mockVisits.length.toString()),
        const StatCard(title: "Countries", value: "1"),
        StatCard(title: "Favorites", value: mockVisits.where((v) => v['isFavorite'] == true).length.toString()),
        const StatCard(title: "Avg Rating", value: "5.0"),
      ],
    );
  }

  Widget _buildRecentVisits() {
    return Column(
      children: mockVisits.reversed.map((visit) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: VisitCard(
          image: "assets/images/placeholder.jpg",
          name: visit['name'],
          location: visit['location'],
          cuisine: visit['cuisine'],
          dishes: visit['dishes'],
        ),
      )).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import 'add_visit_screen.dart';
import 'globe_screen.dart';
import 'welcome_screen.dart'; 
import '../main.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
        // Logo removed and replaced with styled text
        title: Row(
          children: const [
            Text(
              'Foodie', 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
            ),
            Text(
              'Globe', 
              style: TextStyle(color: Color(0xFFFFB703), fontWeight: FontWeight.bold, fontSize: 20)
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.8, -0.6),
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF05050A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildActionButtons(context),
                const SizedBox(height: 40),
                const Text(
                  "Global Stats",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    shadows: [
                      Shadow(color: Colors.blueAccent, blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildStatsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Your Culinary", 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 34, 
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          )
        ),
        Text(
          "Journey", 
          style: TextStyle(
            color: Color(0xFFFFB703), 
            fontSize: 34, 
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          )
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7373EB).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVisitScreen()));
                _refresh();
              },
              icon: const Icon(Icons.add_location_alt_rounded, size: 22),
              label: const Text("ADD VISIT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7373EB), 
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 58,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobeScreen())),
              icon: const Icon(Icons.language_rounded, size: 22),
              label: const Text("GLOBE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFFB703),
                side: const BorderSide(color: Color(0xFFFFB703), width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: const Color(0xFFFFB703).withOpacity(0.05),
              ),
            ),
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
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        StatCard(title: "Total Visits", value: mockVisits.length.toString()),
        const StatCard(title: "Countries", value: "2"),
        StatCard(title: "Favorites", value: mockVisits.where((v) => v['isFavorite'] == true).length.toString()),
        const StatCard(title: "Avg Rating", value: "4.8"),
      ],
    );
  }
}
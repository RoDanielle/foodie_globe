import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/visit_card.dart'; 
import 'add_visit_screen.dart';
import 'globe_screen.dart';
import 'welcome_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Real-time Stream from Firestore - Ordered by newest first
  final Stream<QuerySnapshot> _visitsStream = 
      FirebaseFirestore.instance.collection('visits').orderBy('createdAt', descending: true).snapshots();

  // 1. DELETE CONFIRMATION LOGIC
  void _confirmDelete(String docId, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Visit?", style: TextStyle(color: Colors.white)),
        content: Text("Are you sure you want to remove $name from your globe?", 
                     style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('visits').doc(docId).delete();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 2. DETAIL VIEW POPUP
  void _showVisitDetails(BuildContext context, Map<String, dynamic> data) {
    final List dishesRaw = data['dishes'] as List? ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(data['name'] ?? 'Restaurant', 
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      if (data['isFavorite'] == true) 
                        const Icon(Icons.favorite, color: Colors.red, size: 28),
                    ],
                  ),
                  Text(data['location'] ?? 'Unknown Location', 
                      style: const TextStyle(color: Color(0xFFFFB703), fontSize: 16)),
                  const Divider(color: Colors.white10, height: 40),
                  const Text("DISHES LOGGED", 
                      style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dishesRaw.map((dish) {
                      // SAFE CHECK: Handle both Map (new) and String (old) data
                      if (dish is Map) {
                        return Chip(
                          avatar: dish['isFavorite'] == true ? const Icon(Icons.star, size: 14, color: Colors.amber) : null,
                          label: Text(dish['name']?.toString() ?? "", style: const TextStyle(color: Colors.white, fontSize: 13)),
                          backgroundColor: Colors.white.withOpacity(0.05),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        );
                      } else {
                        return Chip(
                          label: Text(dish.toString(), style: const TextStyle(color: Colors.white, fontSize: 13)),
                          backgroundColor: Colors.white.withOpacity(0.05),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        );
                      }
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        title: Row(
          children: const [
            Text('Foodie', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Globe', style: TextStyle(color: Color(0xFFFFB703), fontWeight: FontWeight.bold, fontSize: 20)),
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
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.8, -0.6),
            radius: 1.5,
            colors: [Color(0xFF1A1A2E), Color(0xFF05050A)],
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
                    shadows: [Shadow(color: Colors.blueAccent, blurRadius: 10)],
                  ),
                ),
                const SizedBox(height: 20),
                _buildStatsGrid(),
                const SizedBox(height: 40),
                const Text(
                  "Recent Journeys",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildVisitsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. THE LIVE LIST WIDGET
  Widget _buildVisitsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _visitsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Sync Error", style: TextStyle(color: Colors.red)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB703)));
        
        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No visits logged yet.", style: TextStyle(color: Colors.white38)));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final docId = docs[index].id;
            final data = docs[index].data() as Map<String, dynamic>;
            
            final List dishesRaw = data['dishes'] as List? ?? [];
            
            // SAFE MAPPING: Handle legacy string data and new Map data
            String dishesSummary = dishesRaw.map((d) => d is Map ? d['name'] : d.toString()).join(', ');

            String displayImageUrl = "";
            if (dishesRaw.isNotEmpty) {
              final firstItem = dishesRaw.first;
              if (firstItem is Map && firstItem['imageUrl'] != null) {
                displayImageUrl = firstItem['imageUrl'];
              }
            }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => _showVisitDetails(context, data),
                onLongPress: () => _confirmDelete(docId, data['name'] ?? 'Restaurant'),
                child: VisitCard(
                  name: data['name'] ?? '',
                  location: data['location'] ?? '',
                  cuisine: data['cuisine'] ?? 'Dining',
                  dishes: dishesSummary,
                  image: displayImageUrl, 
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Your Culinary", style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        Text("Journey", style: TextStyle(color: Color(0xFFFFB703), fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
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
                BoxShadow(color: const Color(0xFF7373EB).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVisitScreen())),
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
    return StreamBuilder<QuerySnapshot>(
      stream: _visitsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Something went wrong", style: TextStyle(color: Colors.white));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFFB703)));
        }

        final docs = snapshot.data!.docs;
        final totalVisits = docs.length;
        final favorites = docs.where((doc) {
           try { return doc['isFavorite'] == true; } catch(e) { return false; }
        }).length;
        final cities = docs.map((doc) => doc['location']).toSet().length;

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            StatCard(title: "Total Visits", value: totalVisits.toString()),
            StatCard(title: "Cities", value: cities.toString()),
            StatCard(title: "Favorites", value: favorites.toString()),
            const StatCard(title: "Avg Rating", value: "4.8"),
          ],
        );
      },
    );
  }
}
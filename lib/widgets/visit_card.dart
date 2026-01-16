import 'package:flutter/material.dart';

class VisitCard extends StatelessWidget {
  final String image;
  final String name;
  final String location;
  final String cuisine;
  final String dishes;

  const VisitCard({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.cuisine,
    required this.dishes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Placeholder for the image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$cuisine • $location",
                  style: const TextStyle(color: Color(0xFFFFB703), fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  dishes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
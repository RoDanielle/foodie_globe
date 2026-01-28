import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VisitCard extends StatelessWidget {
  final String image; // This is now the URL from Firebase
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
        border: Border.all(color: Colors.white.withOpacity(0.05)), // Added subtle border
      ),
      child: Row(
        children: [
          // THE IMAGE SECTION
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.white10,
              child: image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      // Shows while the image is downloading
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFB703)),
                        ),
                      ),
                      // Shows if the link is broken or no internet
                      errorWidget: (context, url, error) => const Icon(
                        Icons.restaurant,
                        color: Colors.white24,
                      ),
                    )
                  : const Icon(Icons.restaurant, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 16),
          // THE TEXT SECTION
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
                const SizedBox(height: 2),
                Text(
                  "$cuisine • $location",
                  style: const TextStyle(color: Color(0xFFFFB703), fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  dishes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
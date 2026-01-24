import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          // Midnight Globe Gradient
          gradient: RadialGradient(
            center: Alignment(0.8, -0.6),
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E), // Midnight Navy
              Color(0xFF05050A), // Deep Space
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER SECTION ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. SMALLER LOGO (No Background)
                    Image.asset(
                      'assets/images/FoodieGlobeLogoNoBG.png',
                      height: 60, // Significantly smaller for a clean look
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.public, color: Color(0xFFFFB703), size: 40),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Foodie",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const Text(
                      "Globe",
                      style: TextStyle(
                        color: Color(0xFFFFB703),
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Trace your culinary adventures across the world.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),

                // --- VISUAL SPACE ---
                // We leave the center spacious to let the gradient breathe
                const Spacer(),

                // --- BUTTON SECTION ---
                Column(
                  children: [
                    // SIGN UP: Primary Glow Button
                    Container(
                      width: double.infinity,
                      height: 60,
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
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7373EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // SIGN IN: Outlined Gold
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFB703),
                          side: const BorderSide(color: Color(0xFFFFB703), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: const Color(0xFFFFB703).withOpacity(0.05),
                        ),
                        child: const Text(
                          "SIGN IN",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Let gradient show
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Account",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          // Consistent Midnight Navy Radial Gradient
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header Section
                const Text(
                  "Join the Globe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create an account to start your journey.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 32),

                // Input Fields
                _buildTextField(hint: "Full Name", icon: Icons.person_outline),
                const SizedBox(height: 16),
                _buildTextField(hint: "Email Address", icon: Icons.mail_outline),
                const SizedBox(height: 16),
                _buildTextField(hint: "Password", icon: Icons.lock_outline, isPassword: true),
                const SizedBox(height: 16),
                _buildTextField(hint: "Confirm Password", icon: Icons.lock_reset_outlined, isPassword: true),
                
                const SizedBox(height: 40),

                // Register Button with Shadow Glow
                Container(
                  width: double.infinity,
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7373EB), 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // Terms and Privacy
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "By creating an account, you agree to our Terms of Service and Privacy Policy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),

                const SizedBox(height: 32),

                // Already have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFFFFB703), // Gold accent
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method updated for Midnight theme
  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C).withOpacity(0.5), // Semi-transparent for glass effect
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10), // Subtle border
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          prefixIcon: Icon(icon, color: const Color(0xFFFFB703), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }
}
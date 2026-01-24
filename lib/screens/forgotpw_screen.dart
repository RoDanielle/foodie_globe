import 'package:flutter/material.dart';

class FrogotPWScreen extends StatelessWidget {
  const FrogotPWScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Let the gradient show through
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
          "Reset Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          // Signature Midnight Navy Radial Gradient
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Header Section
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Enter your email address and we will send you a 4-digit verification code.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Glassmorphic Email Field
                _buildTextField(
                  hint: "Email Address",
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 40),

                // Send Code Button with Glow Shadow
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Reset code sent to your email"),
                          backgroundColor: Color(0xFF7373EB),
                        ),
                      );
                      Navigator.pop(context); // Go back to Login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7373EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "SEND CODE",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 1.1
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Helpful Hint
                const Center(
                  child: Text(
                    "Check your spam folder if you don't see the email.",
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updated glassmorphic text field helper
  Widget _buildTextField({required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C).withOpacity(0.5), // Semi-transparent
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10), // Subtle cosmic border
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: const Color(0xFFFFB703), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
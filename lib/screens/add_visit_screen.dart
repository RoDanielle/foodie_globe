import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart'; // Import mockVisits

class Dish {
  String name;
  bool isFavorite;
  File? image;
  Dish({this.name = "", this.isFavorite = false, this.image});
}

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});
  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final List<Dish> _dishes = [Dish()];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDishImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) setState(() => _dishes[index].image = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by Container
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "New Visit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          // Midnight Globe Gradient
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Restaurant Details", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                const SizedBox(height: 16),
                
                _buildInputContainer(
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Restaurant Name", Icons.restaurant),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInputContainer(
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("City", Icons.location_on_outlined),
                  ),
                ),
                
                const SizedBox(height: 32),
                const Text("What did you eat?", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                const SizedBox(height: 16),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _dishes.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1C).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: GestureDetector(
                        onTap: () => _pickDishImage(index),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _dishes[index].image != null 
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_dishes[index].image!, fit: BoxFit.cover),
                                )
                              : const Icon(Icons.add_a_photo_outlined, color: Color(0xFFFFB703), size: 20),
                        ),
                      ),
                      title: TextField(
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        onChanged: (v) => _dishes[index].name = v,
                        decoration: const InputDecoration(
                          hintText: "שם המנה", 
                          hintStyle: TextStyle(color: Colors.white24),
                          border: InputBorder.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _dishes[index].isFavorite ? Icons.favorite : Icons.favorite_border, 
                          color: _dishes[index].isFavorite ? Colors.red : Colors.white38,
                        ),
                        onPressed: () => setState(() => _dishes[index].isFavorite = !_dishes[index].isFavorite),
                      ),
                    ),
                  ),
                ),
                
                Center(
                  child: TextButton.icon(
                    onPressed: () => setState(() => _dishes.add(Dish())), 
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFFB703)),
                    label: const Text("Add Another Dish", style: TextStyle(color: Color(0xFFFFB703), fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Save Button with Shadow Glow
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7373EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      mockVisits.add({
                        'name': _nameController.text,
                        'location': _cityController.text,
                        'cuisine': 'Dining',
                        'dishes': _dishes.map((d) => d.name).join(', '),
                        'isFavorite': _dishes.any((d) => d.isFavorite),
                      });
                      Navigator.pop(context);
                    }, 
                    child: const Text("SAVE VISIT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2))
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updated glassmorphic styling helpers
  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFFFFB703), size: 20),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }
}
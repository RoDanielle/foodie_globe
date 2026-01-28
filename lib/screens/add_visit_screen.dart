import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Dish {
  String name;
  bool isFavorite;
  File? image;
  String? imageUrl; // Added to store the cloud link
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
  
  bool _isLoading = false;

  // --- IMAGE LOGIC START ---
  Future<void> _showImageSourceOptions(int index) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text("Select Photo Source", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFFB703)),
              title: const Text("Take a Picture", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickDishImage(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFFFB703)),
              title: const Text("Choose from Gallery", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickDishImage(index, ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDishImage(int index, ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source, 
      imageQuality: 70, // Slightly higher quality for cloud storage
      maxWidth: 1000,
    );
    if (pickedFile != null) {
      setState(() => _dishes[index].image = File(pickedFile.path));
    }
  }

  Future<String?> _uploadToStorage(File file) async {
    try {
      String fileName = 'dish_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child('dish_photos/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
  // --- IMAGE LOGIC END ---

  // --- GPS LOGIC ---
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw 'Permission denied';
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _cityController.text = "${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- SAVE LOGIC ---
  Future<void> _saveToFirebase() async {
    if (_nameController.text.trim().isEmpty || _cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in the restaurant name and city")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Upload images and map dishes
      List<Map<String, dynamic>> dishesData = [];
      for (var dish in _dishes) {
        if (dish.name.isNotEmpty) {
          String? cloudUrl;
          if (dish.image != null) {
            cloudUrl = await _uploadToStorage(dish.image!);
          }
          dishesData.add({
            'name': dish.name,
            'isFavorite': dish.isFavorite,
            'imageUrl': cloudUrl ?? "",
          });
        }
      }

      // 2. Geocoding
      List<Location> locations = await locationFromAddress(_cityController.text);
      double lat = locations.isNotEmpty ? locations.first.latitude : 0.0;
      double lng = locations.isNotEmpty ? locations.first.longitude : 0.0;

      // 3. Save to Firestore
      final visitData = {
        'name': _nameController.text.trim(),
        'location': _cityController.text.trim(),
        'lat': lat,
        'lng': lng,
        'cuisine': 'Dining',
        'dishes': dishesData, // Storing full dish objects
        'isFavorite': _dishes.any((d) => d.isFavorite),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('visits').add(visitData);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error saving visit.")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("New Visit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB703)))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Restaurant Details", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
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
                        decoration: _inputDecoration("City", Icons.location_on_outlined).copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location, color: Color(0xFFFFB703)),
                            onPressed: _getCurrentLocation,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text("What did you eat?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dishes.length,
                      itemBuilder: (context, index) => _buildDishTile(index),
                    ),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => setState(() => _dishes.add(Dish())), 
                        icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFFB703)),
                        label: const Text("Add Another Dish", style: TextStyle(color: Color(0xFFFFB703), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7373EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _saveToFirebase, 
                        child: const Text("SAVE TO CLOUD", style: TextStyle(fontWeight: FontWeight.bold))
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildDishTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _showImageSourceOptions(index),
          child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: _dishes[index].image != null 
                ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(_dishes[index].image!, fit: BoxFit.cover))
                : const Icon(Icons.add_a_photo_outlined, color: Color(0xFFFFB703), size: 20),
          ),
        ),
        title: TextField(
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => _dishes[index].name = v,
          decoration: const InputDecoration(hintText: "Dish name", hintStyle: TextStyle(color: Colors.white24), border: InputBorder.none),
        ),
        trailing: IconButton(
          icon: Icon(_dishes[index].isFavorite ? Icons.favorite : Icons.favorite_border, color: _dishes[index].isFavorite ? Colors.red : Colors.white38),
          onPressed: () => setState(() => _dishes[index].isFavorite = !_dishes[index].isFavorite),
        ),
      ),
    );
  }

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
    );
  }
}
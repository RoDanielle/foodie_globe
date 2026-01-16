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
  List<Dish> _dishes = [Dish()];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDishImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) setState(() => _dishes[index].image = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0F),
      appBar: AppBar(title: const Text("New Visit", style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Restaurant Name", labelStyle: TextStyle(color: Colors.white70))
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "City", labelStyle: TextStyle(color: Colors.white70))
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dishes.length,
              itemBuilder: (context, index) => Card(
                color: const Color(0xFF1A1A1C),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () => _pickDishImage(index),
                    child: _dishes[index].image != null 
                        ? Image.file(_dishes[index].image!, width: 50, height: 50, fit: BoxFit.cover) 
                        : const Icon(Icons.camera_alt, color: Colors.white70),
                  ),
                  title: TextField(
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (v) => _dishes[index].name = v,
                    decoration: const InputDecoration(hintText: "שם המנה", hintStyle: TextStyle(color: Colors.white30)),
                  ),
                  trailing: IconButton(
                    icon: Icon(_dishes[index].isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                    onPressed: () => setState(() => _dishes[index].isFavorite = !_dishes[index].isFavorite),
                  ),
                ),
              ),
            ),
            TextButton(onPressed: () => setState(() => _dishes.add(Dish())), child: const Text("Add Another Dish")),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB703), foregroundColor: Colors.black),
                onPressed: () {
                  // SAVE TO MOCK DATABASE
                  mockVisits.add({
                    'name': _nameController.text,
                    'location': _cityController.text,
                    'cuisine': 'Dining',
                    'dishes': _dishes.map((d) => d.name).join(', '),
                    'isFavorite': _dishes.any((d) => d.isFavorite),
                  });
                  Navigator.pop(context);
                }, 
                child: const Text("Save Visit")
              ),
            ),
          ],
        ),
      ),
    );
  }
}
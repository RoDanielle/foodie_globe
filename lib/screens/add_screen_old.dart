import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Dish {
  String name;
  double price;
  bool isFavorite;
  File? image;

  Dish({this.name = "", this.price = 0.0, this.isFavorite = false, this.image});
}

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _nameController = TextEditingController();
  List<Dish> _dishes = [Dish()]; 
  double _overallRating = 3.0;
  final ImagePicker _picker = ImagePicker();

  // Function to pick image for a specific dish index
  Future<void> _pickDishImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _dishes[index].image = File(pickedFile.path);
      });
    }
  }

  void _addDishRow() {
    setState(() => _dishes.add(Dish()));
  }

  void _removeDishRow(int index) {
    setState(() {
      if (_dishes.length > 1) _dishes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Restaurant Visit")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Restaurant Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Restaurant Name",
                prefixIcon: Icon(Icons.place),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Rating
            const Text("Overall Experience:", style: TextStyle(fontWeight: FontWeight.bold)),
            RatingBar.builder(
              initialRating: 3,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => _overallRating = rating,
            ),
            const SizedBox(height: 25),

            // 3. Dynamic Dishes List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("What did you eat?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton.icon(onPressed: _addDishRow, icon: const Icon(Icons.add), label: const Text("Add Dish")),
              ],
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dishes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Dish Image Picker (Thumbnail)
                            GestureDetector(
                              onTap: () => _pickDishImage(index),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: _dishes[index].image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(_dishes[index].image!, fit: BoxFit.cover),
                                      )
                                    : const Icon(Icons.camera_alt, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Dish Name
                            Expanded(
                              flex: 3,
                              child: TextField(
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                onChanged: (val) => _dishes[index].name = val,
                                decoration: const InputDecoration(hintText: "שם המנה", border: InputBorder.none),
                              ),
                            ),
                            // Favorite Heart
                            IconButton(
                              icon: Icon(
                                _dishes[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _dishes[index].isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => setState(() => _dishes[index].isFavorite = !_dishes[index].isFavorite),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 70), // Aligns with the name field
                            // Price
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (val) => _dishes[index].price = double.tryParse(val) ?? 0,
                                decoration: const InputDecoration(
                                  hintText: "מחיר",
                                  prefixText: "₪ ",
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _removeDishRow(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () {
                  // Save Logic
                  Navigator.pop(context);
                },
                child: const Text("Save Visit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
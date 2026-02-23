import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';
import 'package:go_food/GoFood/screens/register_login_screen.dart';
import 'package:go_food/GoFood/styles/color_class.dart';
import 'package:go_food/GoFood/widget/_build_List_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imgController = TextEditingController();
  
  String selectedItem = 'All';
  List<String> categories = ["All", "Burger", "Frise", "Salad"];
  List<Map<String, String>> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard', 
          style: TextStyle(fontWeight: FontWeight.bold, color: ColorClass.headLines)),
        centerTitle: true,
        backgroundColor: ColorClass.primary,
        actions: [
          IconButton(onPressed: () => _signOut(context), icon: const Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            _buildProductForm(),

            const SizedBox(height: 20),
            const Divider(thickness: 2, indent: 20, endIndent: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorClass.primary),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: products.isEmpty
                  ? const Center(child: Text("No products added locally yet"))
                  : BuildListView(products: products),
            ),
            
            const SizedBox(height: 30), 
          ],
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 5, blurRadius: 7),
          ],
        ),
        child: Column(
          children: [
            const Text("Add New Product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildTextField("Product Name", nameController),
            
            DropdownButtonFormField<String>(
              value: selectedItem,
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (newVal) => setState(() => selectedItem = newVal!),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            _buildTextField("Price", priceController),
            _buildTextField("Description", descriptionController, maxLines: 2),
            _buildTextField("Image URL", imgController),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorClass.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                    MealModel newMeal = MealModel(
                      img: imgController.text,
                      name: nameController.text,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      description: descriptionController.text,
                      category: selectedItem,
                    );

                    await addProduct(newMeal);

                    setState(() {
                      products.add({
                        'name': nameController.text,
                        'price': priceController.text,
                      });
                    });

                    nameController.clear(); priceController.clear();
                    descriptionController.clear(); imgController.clear();
                  }
                },
                child: const Text("Add Product", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Future<void> addProduct(MealModel product) async {
    final docRef = FirebaseFirestore.instance.collection('products').doc();
    product = product.copyWith(id: docRef.id);
    await docRef.set(product.toMap());
  }

  Future<void> _signOut(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RegisterLogin()), (route) => false);
    }
  }
}
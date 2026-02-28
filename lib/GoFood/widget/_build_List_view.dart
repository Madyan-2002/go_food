import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildListView extends StatelessWidget {
  final List<Map<String, String>> products;
  const BuildListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return const Divider(color: Colors.grey, thickness: 1);
        },
        itemCount: products.length,
        itemBuilder: (context, index) {
          final String productId = products[index]['id'] ?? "";
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  products[index]['img'] ?? "",
                  fit: BoxFit.cover,
                  // أيقونة تظهر في حال فشل تحميل الصورة
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            title: Text(products[index]['name'] ?? "No Name"),
            subtitle: Text("price : ${products[index]['price']} "),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () =>
                      _showEditDialog(context, productId, products[index]),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProduct(context, productId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String id,
    Map<String, String> currentData,
  ) {
    final TextEditingController nameEdit = TextEditingController(
      text: currentData['name'],
    );
    final TextEditingController priceEdit = TextEditingController(
      text: currentData['price'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Product"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameEdit,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceEdit,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _updateProduct(context, id, nameEdit.text, priceEdit.text);
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(BuildContext context, String id) async {
    if (id.isEmpty) return;
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();

      // إشعار نجاح بسيط
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product deleted successfully")),
      );
    } catch (e) {
      debugPrint("Error deleting product: $e");
    }
  }

  Future<void> _updateProduct(
    BuildContext context,
    String id,
    String newName,
    String newPrice,
  ) async {
    if (id.isEmpty) return;
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).update({
        'name': newName,
        'price': double.tryParse(newPrice) ?? 0.0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product updated successfully")),
      );
    } catch (e) {
      debugPrint("Error updating product: $e");
    }
  }
}

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
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
              ),
            ),
          ),
            title: Text(products[index]['name']!),
            subtitle: Text("price : ${products[index]['price']} "),
            trailing:  IconButton( icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
             
            },)
          );
        },
      ),
    );
  }
}

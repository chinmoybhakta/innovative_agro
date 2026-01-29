import 'package:flutter/material.dart';
import '../../../../core/services/fire_store_service/firestore_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_tile.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Our Products'),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: service.getItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
      
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
      
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No products available'),
                  );
                }
      
                final items = snapshot.data!;
      
                return Column(
                  children: List.generate(items.length, (index)=> ProductCard(item: items[index],)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
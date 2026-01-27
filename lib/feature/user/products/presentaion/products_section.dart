import 'package:flutter/material.dart';
import '../../../../core/services/fire_store_service/firestore_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_tile.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Our Products'),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: service.getItems(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final items = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => ProductCard(item: items[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}

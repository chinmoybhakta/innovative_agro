import 'package:flutter/material.dart';

import '../../../core/models/item_model.dart';
import '../../../core/utils/error_image.dart';
import 'image_carousel.dart';

class ProductCard extends StatelessWidget {
  final ItemModel item;
  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: isSmallScreen
            ? _mobileView()
            : _desktopView(context),
      ),
    );
  }

  // ================= MOBILE VIEW (UNCHANGED) =================
  Widget _mobileView() {
    return SizedBox(
      width: double.infinity,
      height: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 16),
          Expanded(
            child: Image.network(
              item.images?.first ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, e, __) => ErrorImage(error: e),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(item.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(item.brand ?? '',
                    style: const TextStyle(color: Colors.grey)),
                Text(item.description ?? '',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DESKTOP VIEW =================
  Widget _desktopView(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Row(
        children: [
          // IMAGE
          ImageCarousel(images: item.images ?? []),

          // DETAILS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(),
                    const SizedBox(height: 8),
                    _manufacturer(),
                    const Divider(),

                    _chipSection(
                      icon: Icons.science,
                      title: 'Composition',
                      values: item.composition,
                    ),

                    _mapSection(
                      icon: Icons.analytics,
                      title: 'Indicative Composition',
                      data: item.indicatingComposition,
                    ),

                    _chipSection(
                      icon: Icons.thumb_up,
                      title: 'Advantages',
                      values: item.advantages,
                    ),

                    _chipSection(
                      icon: Icons.assignment,
                      title: 'Application',
                      values: item.application,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.name ?? '',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        Text(item.brand ?? '',
            style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        Text(item.description ?? '',
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _manufacturer() {
    if (item.manufacture == null || item.manufacture!.isEmpty) {
      return const SizedBox();
    }
    return Row(
      children: [
        const Icon(Icons.factory, size: 18, color: Colors.green),
        const SizedBox(width: 6),
        Text(
          'Manufacturer: ${item.manufacture}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _chipSection({
    required IconData icon,
    required String title,
    List<String>? values,
  }) {
    if (values == null || values.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(icon, title),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: values
                .map(
                  (e) => Chip(
                label: Text(e),
                backgroundColor: Colors.green.shade50,
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _mapSection({
    required IconData icon,
    required String title,
    Map<String, String>? data,
  }) {
    if (data == null || data.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(icon, title),
          const SizedBox(height: 6),
          ...data.entries.map(
                (e) => Text('• ${e.key}: ${e.value}%'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

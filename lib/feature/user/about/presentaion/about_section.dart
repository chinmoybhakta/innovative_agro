import 'package:flutter/material.dart';
import '../../widgets/section_tile.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'About Us'),
          const SizedBox(height: 24),

          // Company Introduction
          const Text(
            'INNOVATIVE AGRO AID PVT. LTD.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'We are a trusted and innovative agro-based company committed to supporting the agriculture and food industries with high-quality products and reliable solutions.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Mission Card
          Card(
            elevation: 0,
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'To deliver safe, effective, and premium-quality agro and food ingredients sourced from dependable suppliers while maintaining international standards. We focus on innovation, consistency, and customer satisfaction in every aspect of our operations.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Values
          const Text(
            'Our Values',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildValueChip('Integrity'),
              _buildValueChip('Innovation'),
              _buildValueChip('Sustainability'),
              _buildValueChip('Quality'),
              _buildValueChip('Customer Focus'),
            ],
          ),
          const SizedBox(height: 20),

          // Commitment Section
          const Text(
            'Our Commitment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'At INNOVATIVE AGRO AID PVT. LTD., we believe that integrity, innovation, and sustainable growth are the foundations of long-term success. We are dedicated to building lasting relationships with our partners while contributing positively to the agriculture sector.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
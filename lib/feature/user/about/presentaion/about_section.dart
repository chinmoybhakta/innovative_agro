import 'package:flutter/material.dart';

import '../../widgets/section_tile.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: const [
          SectionTitle(title: 'About Us'),
          SizedBox(height: 16),
          Text(
            'Innovative Agro Aid is committed to delivering high-quality agricultural solutions to farmers, dealers, and partners.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

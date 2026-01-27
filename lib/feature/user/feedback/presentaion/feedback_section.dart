import 'package:flutter/material.dart';

import '../../widgets/section_tile.dart';

class FeedbackSection extends StatelessWidget {
  const FeedbackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: const [
          SectionTitle(title: 'Customer Feedback'),
          SizedBox(height: 20),
          Text('⭐⭐⭐⭐⭐  Trusted by hundreds of dealers'),
        ],
      ),
    );
  }
}

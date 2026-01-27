import 'package:flutter/material.dart';
import 'package:innovative_agro_aid/feature/user/home/presentaion/widgets/web_app_bar.dart';

import '../../about/presentaion/about_section.dart';
import '../../contact/presentaion/contact_section.dart';
import '../../feedback/presentaion/feedback_section.dart';
import '../../products/presentaion/products_section.dart';
import 'footer.dart';
import 'hero_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            ProductsSection(),
            AboutSection(),
            FeedbackSection(),
            ContactSection(),
            Footer(),
          ],
        ),
      ),
    );
  }
}

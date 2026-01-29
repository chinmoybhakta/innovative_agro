import 'package:flutter/material.dart';
import 'package:innovative_agro_aid/feature/user/home/presentaion/widgets/web_app_bar.dart';
import '../../about/presentaion/about_section.dart';
import '../../contact/presentaion/contact_section.dart';
import '../../feedback/presentaion/feedback_section.dart';
import '../../products/presentaion/products_section.dart';
import 'footer.dart';
import 'hero_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSection = 0;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of all sections
  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Home',
      'widget': const HeroSection(),
      'icon': Icons.home,
    },
    {
      'title': 'Products',
      'widget': const ProductsSection(),
      'icon': Icons.category,
    },
    {
      'title': 'About',
      'widget': const AboutSection(),
      'icon': Icons.info,
    },
    {
      'title': 'Feedback',
      'widget': const FeedbackSection(),
      'icon': Icons.feedback,
    },
    {
      'title': 'Contact',
      'widget': const ContactSection(),
      'icon': Icons.contact_mail,
    },
  ];

  void _navigateToSection(int sectionIndex) async {
    if (sectionIndex == _currentSection) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _currentSection = sectionIndex;
      _isLoading = false;
    });
  }

  void _navigateToSectionByName(String section) {
    switch (section) {
      case 'home':
        _navigateToSection(0);
        break;
      case 'products':
        _navigateToSection(1);
        break;
      case 'about':
        _navigateToSection(2);
        break;
      case 'feedback':
        _navigateToSection(3);
        break;
      case 'contact':
        _navigateToSection(4);
        break;
      default:
        _navigateToSection(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: WebAppBar(
        scaffoldKey: _scaffoldKey,
        currentIndex: _currentSection,
        onNavigate: _navigateToSectionByName,
      ),
      endDrawer: isSmallScreen ? _buildMobileDrawer(context) : null,
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
                : _buildCurrentSection(),
          ),
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildCurrentSection() {
    if (_currentSection == 0) {
      // Home section with hero and navigation previews
      return SingleChildScrollView(
        child: Column(
          children: [
            _sections[0]['widget'] as Widget,
            const SizedBox(height: 40),
            _buildSectionNavigationPreviews(),
          ],
        ),
      );
    } else {
      // Other sections
      return SingleChildScrollView(
        child: _sections[_currentSection]['widget'] as Widget,
      );
    }
  }

  Widget _buildSectionNavigationPreviews() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            'Explore Our Sections',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Navigate to different sections of our website',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _sections.sublist(1).asMap().entries.map((entry) {
              final index = entry.key + 1; // Start from 1 (skip home)
              final section = entry.value;

              return InkWell(
                onTap: () => _navigateToSection(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          section['icon'] as IconData,
                          size: 30,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        section['title'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSectionDescription(section['title'] as String),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          // Back to top button (for when user scrolls down)
          if (_currentSection == 0) ...[
            const Divider(height: 40),
            TextButton.icon(
              onPressed: () {
                // Scroll to top
                PrimaryScrollController.of(context).animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_upward, size: 16),
              label: const Text('Back to Top'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getSectionDescription(String title) {
    switch (title) {
      case 'Products':
        return 'Discover our agricultural products and solutions';
      case 'About':
        return 'Learn about our mission, vision, and values';
      case 'Feedback':
        return 'Share your valuable feedback with us';
      case 'Contact':
        return 'Get in touch with our support team';
      default:
        return '';
    }
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.agriculture, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                const Text(
                  'Innovative Agro Aid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Section: ${_sections[_currentSection]['title']}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _sections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;

                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _currentSection == index
                          ? Colors.green.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      section['icon'] as IconData,
                      color: _currentSection == index
                          ? Colors.green
                          : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  title: Text(
                    section['title'] as String,
                    style: TextStyle(
                      fontWeight: _currentSection == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _currentSection == index
                          ? Colors.green
                          : Colors.black87,
                    ),
                  ),
                  trailing: _currentSection == index
                      ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  )
                      : const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToSection(index);
                  },
                );
              }).toList(),
            ),
          ),

          // Current Section Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_sections[_currentSection]['title']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentSection + 1}/${_sections.length}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class WebAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final int currentIndex;
  final Function(String)? onNavigate;

   WebAppBar({
    super.key,
    this.scaffoldKey,
    this.currentIndex = 0,
    this.onNavigate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Home', 'icon': Icons.home, 'section': 'home'},
    {'title': 'Products', 'icon': Icons.category, 'section': 'products'},
    {'title': 'About', 'icon': Icons.info, 'section': 'about'},
    {'title': 'Feedback', 'icon': Icons.feedback, 'section': 'feedback'},
    {'title': 'Contact', 'icon': Icons.contact_mail, 'section': 'contact'},
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 650;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (onNavigate != null) {
              onNavigate!('home');
            }
          },
          child: Row(
            children: [
              Icon(Icons.agriculture, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Innovative Agro Aid',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: isSmallScreen
          ? [
        // Hamburger menu button for small screens
        IconButton(
          onPressed: () {
            if (scaffoldKey != null) {
              scaffoldKey!.currentState?.openEndDrawer();
            } else {
              Scaffold.of(context).openEndDrawer();
            }
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
      ]
          : [
        // Desktop navigation items
        ..._menuItems.asMap().entries.map(
              (entry) => _NavItem(
            title: entry.value['title'] as String,
            isActive: currentIndex == entry.key,
            onTap: () {
              if (onNavigate != null) {
                onNavigate!(entry.value['section'] as String);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: isActive
                ? const Border(
              bottom: BorderSide(
                color: Colors.green,
                width: 3,
              ),
            )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.black87,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
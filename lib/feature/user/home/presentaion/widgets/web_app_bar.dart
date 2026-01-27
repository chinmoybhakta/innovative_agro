import 'package:flutter/material.dart';

class WebAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WebAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Innovative Agro Aid',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _NavItem(title: 'Home'),
        _NavItem(title: 'Products'),
        _NavItem(title: 'About'),
        _NavItem(title: 'Feedback'),
        _NavItem(title: 'Contact'),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  const _NavItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // later: scroll to section
      },
      child: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

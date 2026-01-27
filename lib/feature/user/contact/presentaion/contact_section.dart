import 'package:flutter/material.dart';
import '../../../../core/services/fire_store_service/firestore_service.dart';
import '../../widgets/section_tile.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return StreamBuilder(
      stream: service.getContact(),
      builder: (_, snapshot) {
        final contact = snapshot.data;
        if (contact == null) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const SectionTitle(title: 'Contact Us'),
              Text(contact.address ?? ''),
              Text(contact.email ?? ''),
              Text('WhatsApp: ${contact.whatsapp ?? ''}'),
            ],
          ),
        );
      },
    );
  }
}

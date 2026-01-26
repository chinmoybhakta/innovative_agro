import 'package:flutter/material.dart';
import '../../../../core/models/contact_model.dart';
import '../../../../core/services/fire_store_service/firestore_service.dart';

class EditContactDetails extends StatefulWidget {
  const EditContactDetails({super.key});

  @override
  State<EditContactDetails> createState() => _EditContactDetailsState();
}

class _EditContactDetailsState extends State<EditContactDetails> {
  final service = FirestoreService();

  bool _isSaving = false;
  String _docId = '';

  final address = TextEditingController();
  final email = TextEditingController();
  final facebook = TextEditingController();
  final whatsapp = TextEditingController();
  List<TextEditingController> phones = [];

  @override
  void initState() {
    super.initState();

    // Listen to Firestore contact data once and populate
    service.getContact().listen((contact) {
      if (contact != null && _docId.isEmpty) {
        _docId = contact.id;
        address.text = contact.address ?? '';
        email.text = contact.email ?? '';
        facebook.text = contact.facebookUrl ?? '';
        whatsapp.text = contact.whatsapp ?? '';
        phones = (contact.phone ?? [])
            .map((e) => TextEditingController(text: e))
            .toList();

        // Trigger rebuild to show phones
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    address.dispose();
    email.dispose();
    facebook.dispose();
    whatsapp.dispose();
    for (final p in phones) p.dispose();
    super.dispose();
  }

  void _populate(ContactModel contact) {
    _docId = contact.id;
    address.text = contact.address ?? '';
    email.text = contact.email ?? '';
    facebook.text = contact.facebookUrl ?? '';
    whatsapp.text = contact.whatsapp ?? '';

    phones = (contact.phone ?? [])
        .map((e) => TextEditingController(text: e))
        .toList();
  }

  Widget _phoneEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Numbers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...phones.map(
              (c) => Row(
            children: [
              Expanded(
                child: TextField(
                  controller: c,
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => setState(() => phones.remove(c)),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () =>
              setState(() => phones.add(TextEditingController())),
          child: const Text('Add phone'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    String? normalize(String value) =>
        value.trim().isEmpty ? null : value.trim();

    try {
      final contact = ContactModel(
        id: _docId,
        address: normalize(address.text),
        email: normalize(email.text),
        facebookUrl: normalize(facebook.text),
        whatsapp: normalize(whatsapp.text),
        phone: phones
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      );

      await service.saveContact(contact);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact details saved'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save contact'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ContactModel?>(
      stream: service.getContact(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && _docId.isEmpty) {
          _populate(snapshot.data!);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Contact Details'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: address,
                  decoration:
                  const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: facebook,
                  decoration:
                  const InputDecoration(labelText: 'Facebook URL'),
                ),
                TextField(
                  controller: whatsapp,
                  decoration:
                  const InputDecoration(labelText: 'WhatsApp'),
                ),
                const SizedBox(height: 20),
                _phoneEditor(),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

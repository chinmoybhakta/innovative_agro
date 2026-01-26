import 'package:flutter/material.dart';
import 'package:innovative_agro_aid/core/services/fire_store_service/firestore_service.dart';
import '../../../../core/models/item_model.dart';

class AddEditItemScreen extends StatefulWidget {
  final ItemModel? item;
  const AddEditItemScreen({super.key, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  bool _isSaving = false;

  final service = FirestoreService();

  final name = TextEditingController();
  final brand = TextEditingController();
  final description = TextEditingController();
  final manufacture = TextEditingController();

  List<TextEditingController> imageUrls = [];
  List<TextEditingController> compositions = [];
  List<TextEditingController> advantages = [];
  List<TextEditingController> applications = [];

  Map<TextEditingController, TextEditingController> indicative = {};

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      final item = widget.item!;
      name.text = item.name ?? "";
      brand.text = item.brand ?? "";
      description.text = item.description ?? "";
      manufacture.text = item.manufacture ?? "";

      imageUrls = (item.images ?? [])
          .map((e) => TextEditingController(text: e.isNotEmpty ? e : ""))
          .toList();
      compositions = (item.composition ?? [])
          .map((e) => TextEditingController(text: e))
          .toList();
      advantages = (item.advantages ?? [])
          .map((e) => TextEditingController(text: e))
          .toList();
      applications = (item.application ?? [])
          .map((e) => TextEditingController(text: e))
          .toList();

      (item.indicatingComposition ?? {}).forEach((key, value) {
        indicative[TextEditingController(text: key)] = TextEditingController(
          text: value,
        );
      });
    }
  }

  Widget listEditor(String title, List<TextEditingController> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...list.map(
          (c) => Row(
            children: [
              Expanded(child: TextField(controller: c)),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => setState(() => list.remove(c)),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => setState(() => list.add(TextEditingController())),
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget mapEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Indicative Composition',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...indicative.entries.map(
          (e) => Row(
            children: [
              Expanded(
                child: TextField(
                  controller: e.key,
                  decoration: const InputDecoration(hintText: 'Key'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: e.value,
                  decoration: const InputDecoration(hintText: 'Value'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => setState(() => indicative.remove(e.key)),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => setState(
            () => indicative[TextEditingController()] = TextEditingController(),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    String? normalize(String value) =>
        value.trim().isEmpty ? null : value.trim();

    try {
      final item = ItemModel(
        id: widget.item?.id ?? '',
        name: normalize(name.text),
        brand: normalize(brand.text),
        description: normalize(description.text),
        manufacture: normalize(manufacture.text),
        images: imageUrls
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        composition: compositions
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        advantages: advantages
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        application: applications
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        indicatingComposition: {
          for (var e in indicative.entries)
            if (e.key.text.trim().isNotEmpty)
              e.key.text.trim(): e.value.text.trim(),
        },
      );

      if (widget.item == null) {
        await service.addItem(item);
      } else {
        await service.updateItem(item);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.item == null
                ? 'Item added successfully'
                : 'Item updated successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Save failed: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save item'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: brand,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: manufacture,
              decoration: const InputDecoration(labelText: 'Manufactured by'),
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            listEditor('Image URLs', imageUrls),
            listEditor('Composition', compositions),
            mapEditor(),
            listEditor('Advantages', advantages),
            listEditor('Application', applications),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : save,
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

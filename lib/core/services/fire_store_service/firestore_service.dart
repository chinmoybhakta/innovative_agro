import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/contact_model.dart';
import '../../models/item_model.dart';

class FirestoreService {
  final _itemsRef =
  FirebaseFirestore.instance.collection('Items');

  final _contactsRef =
  FirebaseFirestore.instance.collection('contacts');

  Map<String, dynamic> _clean(Map<String, dynamic> data) {
    data.removeWhere((key, value) =>
    value == null ||
        (value is List && value.isEmpty) ||
        (value is Map && value.isEmpty));
    return data;
  }

  Stream<List<ItemModel>> getItems() {
    return _itemsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> addItem(ItemModel item) async {
    await _itemsRef.add(_clean(item.toMap()));
  }

  Future<void> updateItem(ItemModel item) async {
    await _itemsRef.doc(item.id).update(_clean(item.toMap()));
  }

  Future<void> deleteItem(String id) async {
    await _itemsRef.doc(id).delete();
  }

  Stream<ContactModel?> getContact() {
    return _contactsRef.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return ContactModel.fromMap(doc.id, doc.data());
    });
  }

  Future<void> saveContact(ContactModel contact) async {
    final data = _clean(contact.toMap());

    if (contact.id.isEmpty) {
      await _contactsRef.add(data);
    } else {
      await _contactsRef
          .doc(contact.id)
          .set(data, SetOptions(merge: true));
    }
  }
}

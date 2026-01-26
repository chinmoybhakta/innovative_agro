import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:innovative_agro_aid/core/services/fire_store_service/firestore_service.dart';
import 'package:innovative_agro_aid/feature/admin/dashboard/presentaion/edit_contact_details.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../auth/presentaion/auth_gate.dart';
import 'add_edit_item_screen.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();


    return Scaffold(
        appBar: AppBar(title: const Text('Hello Admin'), actions: [
          IconButton(onPressed: ()async{
            await AuthService().signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AuthGate()), (route) => false);
          }, icon: const Icon(Icons.logout))
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditItemScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Text("All items", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
            Expanded(
              child: StreamBuilder<List<ItemModel>>(
                  stream: service.getItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No items found'));
                    }
              
              
                    final items = snapshot.data!;
              
              
                    return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = items[index];
              
              
                          return ListTile(
                            title: Text(item.name ?? ""),
                            subtitle: Text(((item.brand ?? "") == "")
                                ? item.manufacture ?? ""
                                : item.brand ?? ""),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await service.deleteItem(item.id);
                                } catch (e) {
                                  log('Delete failed: $e');
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditItemScreen(item: item),
                                ),
                              );
                            },
                          );
                        },
                    );
                  },
              ),
            ),
            InkWell(child: Text("Edit Contacts Details"), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const EditContactDetails())),),
            Text("All Rights Reserved @CHINMOYBHAKTA")
          ],
        ),
    );
  }
}
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/const/network_img.dart';
import '../../../../core/utils/error_image.dart';
import '../../dashboard/presentaion/dashboard_screen.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final loading = false;

  final email = TextEditingController();
  final password = TextEditingController();


  Future<void> login() async {
    try {
      final authResponse = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // Authentication successful
      log('User UID: ${authResponse.user?.uid}');
      log('User email: ${authResponse.user?.email}');

      Fluttertoast.showToast(msg: "Successful Login");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen())
      );

    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      log('Firebase Auth Error Code: ${e.code}');
      log('Firebase Auth Error Message: ${e.message}');
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      // Handle other errors
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(mainAxisSize: MainAxisSize.min, spacing: 12, children: [
            Image.network(NetworkImg.logo, errorBuilder: (context, error, stackTrace){
              return ErrorImage(error: error);
            }),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text('Login'))
          ]),
        ),
      ),
    );
  }
}
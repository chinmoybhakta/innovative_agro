import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../dashboard/presentaion/dashboard_screen.dart';


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});


  @override
  State<AdminLogin> createState() => _AdminLoginState();
}


class _AdminLoginState extends State<AdminLogin> {
  final email = TextEditingController();
  final password = TextEditingController();


  Future<void> login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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
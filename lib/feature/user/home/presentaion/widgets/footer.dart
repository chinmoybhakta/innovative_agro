import 'package:flutter/material.dart';
import 'package:innovative_agro_aid/feature/admin/auth/presentaion/auth_gate.dart';
import 'package:innovative_agro_aid/feature/user/home/presentaion/privacy_policy.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>PrivacyPolicy())),
              child: Text(
                  'Privacy policy'
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>AuthGate())),
              child: Text(
                  'Admin portal'
              ),
            ),
          ],
        ),
        Text(
          '© 2026 Innovative Agro Aid'
        ),
      ],
    );
  }
}

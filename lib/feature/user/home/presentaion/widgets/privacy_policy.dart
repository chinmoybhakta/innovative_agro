import 'package:flutter/material.dart';
import '../../../widgets/section_tile.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Privacy Policy'),
          const SizedBox(height: 24),

          const Text(
            'INNOVATIVE AGRO AID PVT. LTD. is committed to safeguarding the privacy and security of personal information collected from our customers, partners, and website visitors.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Information Collection
          _buildPolicySection(
            title: 'Information We Collect',
            content: 'We may collect personal identification information (name, phone number, email address), business or contact information provided through inquiries or transactions, and information related to the use of our website, products, or services.',
          ),

          // Purpose
          _buildPolicySection(
            title: 'Purpose of Data Collection',
            content: 'To provide, operate, and improve our products and services; to communicate with customers regarding inquiries, orders, and support; to ensure business continuity, compliance, and service quality.',
          ),

          // Data Protection
          _buildPolicySection(
            title: 'Data Protection and Security',
            content: 'We implement appropriate technical, organizational, and administrative measures to protect personal information against unauthorized access, alteration, disclosure, or destruction.',
          ),

          // Information Sharing
          _buildPolicySection(
            title: 'Information Sharing and Disclosure',
            content: 'We do not sell, trade, or rent personal information to third parties. Information may be disclosed only when required by applicable laws, regulations, or lawful requests from authorities.',
          ),

          // Cookies
          _buildPolicySection(
            title: 'Cookies and Website Analytics',
            content: 'Our website may use cookies and similar technologies to enhance user experience, monitor website performance, and improve service delivery. Users may choose to disable cookies through their browser settings.',
          ),

          // Retention
          _buildPolicySection(
            title: 'Retention of Information',
            content: 'Personal information is retained only for as long as necessary to fulfill the purposes outlined in this policy or as required by law.',
          ),

          // Changes
          _buildPolicySection(
            title: 'Changes to This Policy',
            content: 'The Company reserves the right to update or revise this Privacy Policy at any time. Any changes will be effective upon publication.',
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),

          const Text(
            'INNOVATIVE AGRO AID PVT. LTD.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/contact_model.dart';
import '../../../../core/services/email_service/api_service.dart';
import '../../../../core/services/fire_store_service/firestore_service.dart';
import '../../widgets/challenge_generator.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _body = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _challengeAnswer = TextEditingController();

  Map<String, dynamic>? _currentChallenge;
  bool _challengeSolved = false;
  bool _isSending = false;
  DateTime? _lastSendTime;
  int _consecutiveAttempts = 0;

  final FirestoreService _firestoreService = FirestoreService();
  ContactModel? _contactInfo;

  @override
  void initState() {
    super.initState();
    _generateChallenge();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load contact info from Firestore
    _loadContactInfo();
  }

  void _loadContactInfo() {
    _firestoreService.getContact().listen((contact) {
      if (mounted) {
        setState(() {
          _contactInfo = contact;
        });
      }
    });
  }

  void _generateChallenge() {
    setState(() {
      _currentChallenge = ChallengeGenerator.generateSimpleChallenge();
      _challengeAnswer.clear();
      _challengeSolved = false;
    });
  }

  void _verifyChallenge() {
    final userAnswer = _challengeAnswer.text.trim();
    final correctAnswer = _currentChallenge?['answer']?.toString().trim() ?? '';

    if (userAnswer.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your answer');
      return;
    }

    if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
      setState(() {
        _challengeSolved = true;
      });
      Fluttertoast.showToast(msg: '✓ Verified');
    } else {
      _consecutiveAttempts++;

      if (_consecutiveAttempts >= 2) {
        Fluttertoast.showToast(
          msg: 'Too many wrong answers. New challenge generated.',
          backgroundColor: Colors.grey[700],
        );
        _generateChallenge();
        _consecutiveAttempts = 0;
      } else {
        Fluttertoast.showToast(
          msg: 'Incorrect. Try again.',
          backgroundColor: Colors.grey[700],
        );
      }
    }
  }

  // Launch URLs
  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $url');
    }
  }

  // Copy phone number to clipboard
  Future<void> _copyPhoneNumber(String phoneNumber) async {
    await Clipboard.setData(ClipboardData(text: phoneNumber));
    Fluttertoast.showToast(
      msg: 'Phone number copied to clipboard',
      backgroundColor: Colors.grey[700],
    );
  }

  // Launch email
  Future<void> _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(msg: 'Could not launch email');
    }
  }

  // Rate limiting: prevent too frequent submissions
  bool get _canSendEmail {
    if (_lastSendTime == null) return true;

    final now = DateTime.now();
    final diff = now.difference(_lastSendTime!);

    // Allow 1 email every 30 seconds
    return diff.inSeconds >= 30;
  }

  Future<void> _sendEmail() async {
    // Check rate limit
    if (!_canSendEmail) {
      Fluttertoast.showToast(
        msg: 'Please wait 30 seconds before sending another email',
        backgroundColor: Colors.grey[700],
      );
      return;
    }

    // Validate form
    if (!_validateForm()) return;

    // Check challenge
    if (!_challengeSolved) {
      Fluttertoast.showToast(msg: 'Please solve the challenge first');
      return;
    }

    setState(() => _isSending = true);
    _lastSendTime = DateTime.now();

    try {
      // Use the submitContactForm method
      final response = await ApiService.submitContactForm(
        name: _name.text.trim(),
        email: _email.text.trim(),
        subject: _subject.text.trim(),
        message: _body.text.trim(),
        phone: _phone.text.trim(),
      );

      if (response['success'] == true) {
        _showSuccess(response['message'] ?? 'Message sent successfully!');
        _clearForm();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed: ${response['message'] ?? 'Unknown error'}',
          backgroundColor: Colors.grey[700],
        );
      }
    } catch (e) {
      String errorMsg = e.toString().replaceAll('Exception: ', '');

      // Check if it's a validation error
      if (errorMsg.contains('must be at least') ||
          errorMsg.contains('Invalid email') ||
          errorMsg.contains('Please enter')) {
        Fluttertoast.showToast(
          msg: errorMsg,
          backgroundColor: Colors.grey[700],
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Error: $errorMsg',
          backgroundColor: Colors.grey[700],
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  bool _validateForm() {
    if (_name.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your name');
      return false;
    }

    if (_name.text.trim().length < 2) {
      Fluttertoast.showToast(msg: 'Name must be at least 2 characters');
      return false;
    }

    final email = _email.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your email');
      return false;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(msg: 'Please enter a valid email address');
      return false;
    }

    if (_subject.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a subject');
      return false;
    }

    if (_subject.text.trim().length < 3) {
      Fluttertoast.showToast(msg: 'Subject must be at least 3 characters');
      return false;
    }

    if (_body.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your message');
      return false;
    }

    if (_body.text.trim().length < 10) {
      Fluttertoast.showToast(msg: 'Message must be at least 10 characters');
      return false;
    }

    return true;
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: '✓ $message',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );

    // Generate new challenge after successful send
    Future.delayed(const Duration(seconds: 2), () {
      _generateChallenge();
    });
  }

  void _clearForm() {
    _subject.clear();
    _body.clear();
    _email.clear();
    _name.clear();
    _phone.clear();
    setState(() {
      _challengeSolved = false;
      _consecutiveAttempts = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Contact Info from Firestore
          if (_contactInfo != null) _buildContactInfo(),

          const SizedBox(height: 20),

          // Contact Form
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Form',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'All fields marked with * are required',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Your Name *',
                      labelStyle: const TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                      ),
                      prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Your Email *',
                      labelStyle: const TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone (Optional)
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      labelStyle: const TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                      ),
                      prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subject
                  TextField(
                    controller: _subject,
                    decoration: InputDecoration(
                      labelText: 'Subject *',
                      labelStyle: const TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                      ),
                      prefixIcon: const Icon(Icons.title, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Message *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _body,
                          maxLines: 4,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type your message here...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${_body.text.length} characters',
                            style: TextStyle(
                              fontSize: 12,
                              color: _body.text.length < 10
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Challenge Section
                  _buildChallengeSection(),
                  const SizedBox(height: 24),

                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendEmail,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _challengeSolved ? Colors.black87 : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isSending
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        'Send Message',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Address
          if (_contactInfo?.address != null && _contactInfo!.address!.isNotEmpty)
            _buildContactItem(
              icon: Icons.location_on,
              title: 'Address',
              content: _contactInfo!.address!,
            ),

          // Phone Numbers
          if (_contactInfo?.phone != null && _contactInfo!.phone!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Phone Numbers:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ..._contactInfo!.phone!.map((phone) => _buildContactItem(
                  icon: Icons.phone,
                  title: null,
                  content: phone,
                  onTap: () => _copyPhoneNumber(phone),
                )).toList(),
              ],
            ),

          // Email
          if (_contactInfo?.email != null && _contactInfo!.email!.isNotEmpty)
            _buildContactItem(
              icon: Icons.email,
              title: 'Email',
              content: _contactInfo!.email!,
              onTap: () => _launchEmail(_contactInfo!.email!),
            ),

          // WhatsApp
          if (_contactInfo?.whatsapp != null && _contactInfo!.whatsapp!.isNotEmpty)
            _buildContactItem(
              icon: Icons.message,
              title: 'WhatsApp',
              content: _contactInfo!.whatsapp!,
              onTap: () => _launchUrl('https://wa.me/${_contactInfo!.whatsapp!}'),
            ),

          // Facebook
          if (_contactInfo?.facebookUrl != null && _contactInfo!.facebookUrl!.isNotEmpty)
            _buildContactItem(
              icon: Icons.facebook,
              title: 'Facebook',
              content: 'Visit our Facebook page',
              onTap: () => _launchUrl(_contactInfo!.facebookUrl!),
            ),

          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          Text(
            'Prefer to contact us directly? Use the form below to send us a message.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String? title,
    required String content,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (title != null) const SizedBox(height: 2),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _challengeSolved ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: _challengeSolved ? Colors.green : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _challengeSolved ? '✓ Verified' : 'Security Check Required',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _challengeSolved ? Colors.green : Colors.black87,
                  ),
                ),
              ),
              if (!_challengeSolved)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18, color: Colors.grey),
                  onPressed: _generateChallenge,
                  tooltip: 'New challenge',
                ),
            ],
          ),

          if (_currentChallenge != null && !_challengeSolved) ...[
            const SizedBox(height: 12),
            Text(
              _currentChallenge!['question'],
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _challengeAnswer,
                    decoration: InputDecoration(
                      hintText: 'Enter answer...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check, color: Colors.grey),
                        onPressed: _verifyChallenge,
                      ),
                    ),
                    onSubmitted: (_) => _verifyChallenge(),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _verifyChallenge,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),

            if (_currentChallenge!['hint'] != null) ...[
              const SizedBox(height: 8),
              Text(
                '💡 ${_currentChallenge!['hint']}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],

          if (_challengeSolved) ...[
            const SizedBox(height: 8),
            Text(
              'You can now send your message',
              style: TextStyle(color: Colors.green[800], fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
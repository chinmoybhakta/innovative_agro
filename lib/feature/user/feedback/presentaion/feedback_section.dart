import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/services/email_service/api_service.dart';
import '../../widgets/challenge_generator.dart';

class FeedbackSection extends StatefulWidget {
  const FeedbackSection({super.key});

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final TextEditingController _challengeAnswer = TextEditingController();

  Map<String, dynamic>? _currentChallenge;
  bool _challengeSolved = false;
  bool _isSending = false;
  DateTime? _lastSendTime;
  int _consecutiveAttempts = 0;

  // Predefined subject for feedback
  static const String _feedbackSubject = "Customer Feedback - Innovative Agro Aid";

  @override
  void initState() {
    super.initState();
    _generateChallenge();
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

  // Rate limiting: prevent too frequent submissions
  bool get _canSendFeedback {
    if (_lastSendTime == null) return true;

    final now = DateTime.now();
    final diff = now.difference(_lastSendTime!);

    // Allow 1 feedback every 30 seconds
    return diff.inSeconds >= 30;
  }

  Future<void> _submitFeedback() async {
    // Check rate limit
    if (!_canSendFeedback) {
      Fluttertoast.showToast(
        msg: 'Please wait 30 seconds before submitting another feedback',
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
      // Use the submitContactForm method with predefined subject
      final response = await ApiService.submitContactForm(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        subject: _feedbackSubject, // Predefined subject
        message: _messageController.text.trim(),
        phone: '', // No phone for feedback
      );

      if (response['success'] == true) {
        _showSuccess(response['message'] ?? 'Feedback submitted successfully!');
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
    // Name validation
    if (_nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your name');
      return false;
    }

    if (_nameController.text.trim().length < 2) {
      Fluttertoast.showToast(msg: 'Name must be at least 2 characters');
      return false;
    }

    // Email validation
    final email = _emailController.text.trim();
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

    // Message validation
    if (_messageController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your feedback message');
      return false;
    }

    if (_messageController.text.trim().length < 10) {
      Fluttertoast.showToast(msg: 'Feedback must be at least 10 characters');
      return false;
    }

    return true;
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: '✓ $message',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );

    // Generate new challenge after successful submission
    Future.delayed(const Duration(seconds: 2), () {
      _generateChallenge();
    });
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() {
      _challengeSolved = false;
      _consecutiveAttempts = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          const SizedBox(height: 10),
          const Text(
            'Share Your Feedback',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your thoughts help us improve our services and serve you better.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          // Feedback Form
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All fields are required',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
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
                  const SizedBox(height: 20),

                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Your Email',
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
                  const SizedBox(height: 20),

                  // Message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Feedback',
                        style: TextStyle(
                          fontSize: 16,
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
                          controller: _messageController,
                          maxLines: 6,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            hintText: 'Tell us what you think...\n\n• What did you like?\n• What can we improve?\n• Any suggestions?',
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
                            '${_messageController.text.length} characters',
                            style: TextStyle(
                              fontSize: 12,
                              color: _messageController.text.length < 10
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Challenge Section
                  _buildChallengeSection(),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: _challengeSolved ? Colors.black87 : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isSending
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        'Submit Feedback',
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

          // Info Section
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.grey, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What happens next?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You will receive an auto-reply email confirming we received your feedback. '
                            'Our team reviews all feedback regularly.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _challengeSolved ? '✓ Verified - Ready to Submit' : 'Security Check Required',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _challengeSolved ? Colors.green : Colors.black87,
                  ),
                ),
              ),
              if (!_challengeSolved)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _generateChallenge,
                  tooltip: 'New challenge',
                  color: Colors.grey,
                ),
            ],
          ),

          if (_currentChallenge != null && !_challengeSolved) ...[
            const SizedBox(height: 16),
            Text(
              _currentChallenge!['question'],
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _challengeAnswer,
                    decoration: InputDecoration(
                      hintText: 'Enter your answer here...',
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
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _verifyChallenge,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            if (_currentChallenge!['hint'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentChallenge!['hint'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          if (_challengeSolved) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Security check passed! You can now submit your feedback.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _challengeAnswer.dispose();
    super.dispose();
  }
}
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://innovative-agro-smtp.onrender.com';

  // Test the new endpoint
  static Future<bool> testConnection() async {
    try {
      log("Testing API connection...");
      log("URL: $baseUrl/health");

      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Accept': 'application/json'},
      );

      log("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("API Response: $data");

        // Check if ProMailer is configured
        final promailerConfigured = data['promailer']?['configured'] ?? false;
        log("ProMailer Configured: $promailerConfigured");

        return true;
      } else {
        log("Connection failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Connection error: $e");
      return false;
    }
  }

  // Test ProMailer API connection specifically
  static Future<Map<String, dynamic>> testProMailer() async {
    try {
      log("Testing ProMailer connection...");
      log("URL: $baseUrl/test/promailer");

      final response = await http.get(
        Uri.parse('$baseUrl/test/promailer'),
        headers: {'Accept': 'application/json'},
      );

      log("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("ProMailer Test Result: $data");
        return data;
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      log("ProMailer test error: $e");
      rethrow;
    }
  }

  // Submit contact form (NEW ENDPOINT)
  static Future<Map<String, dynamic>> submitContactForm({
    required String name,
    required String email,
    required String subject,
    required String message,
    String phone = '',
  }) async {
    try {
      log("Submitting contact form...");
      log("URL: $baseUrl/api/contact");
      log("Data: {name: $name, email: $email, subject: $subject, message length: ${message.length}}");

      final response = await http.post(
        Uri.parse('$baseUrl/api/contact'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
          'phone': phone,
        }),
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Success: ${data['success']}");
        log("Message: ${data['message']}");
        return data;
      } else if (response.statusCode == 400) {
        // Validation error
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Invalid form data');
      } else if (response.statusCode == 500) {
        // Server error
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Server error. Please try again later.');
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      log("Submit form error: $e");
      rethrow;
    }
  }

  // Send test email
  static Future<Map<String, dynamic>> sendTestEmail() async {
    try {
      log("Sending test email...");
      log("URL: $baseUrl/test/email");

      final response = await http.get(
        Uri.parse('$baseUrl/test/email'),
        headers: {'Accept': 'application/json'},
      );

      log("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Test Email Result: $data");
        return data;
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      log("Test email error: $e");
      rethrow;
    }
  }

  // Get API info
  static Future<Map<String, dynamic>> getApiInfo() async {
    try {
      log("Getting API info...");
      log("URL: $baseUrl/");

      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("API Info: $data");
        return data;
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      log("API info error: $e");
      rethrow;
    }
  }
}
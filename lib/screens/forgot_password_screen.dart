import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:vollify_app/services/api_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();

  void _handleForgotPassword(BuildContext context) async {
    if (_emailController.text.isEmpty) {
      _showError(context, 'Please enter your email address.');
      return;
    }

    try {
      // Call the sendResetPasswordEmail method from ApiService
      final response = await _apiService.forgotPassword(
        email: _emailController.text.trim(),
        role: 'volunteer', // or 'organization' depending on the screen context
      );

      if (response.statusCode == 200) {
        _showMessage(context, 'Password reset email sent successfully!');
      } else {
        // Handle API errors
        final responseData = jsonDecode(response.body);
        _showError(
          context,
          responseData['message'] ?? 'Failed to send reset email.',
        );
      }
    } catch (e) {
      _showError(context, 'An error occurred: $e');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFF20331B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your email address to receive a password reset link.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _handleForgotPassword(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Send Reset Link',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

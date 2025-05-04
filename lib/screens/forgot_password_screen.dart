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
      final response = await _apiService.forgotPassword(
        email: _emailController.text.trim(),
        role: 'volunteer',
      );

      if (response.statusCode == 200) {
        _showMessage(context, 'Password reset email sent successfully!');
      } else {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B),
        elevation: 0,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/icon/forgot_password.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Reset your password',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF20331B),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter your email address and we’ll send you a link to reset your password.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _handleForgotPassword(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF20331B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Send Reset Link',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

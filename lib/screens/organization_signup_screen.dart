import 'package:flutter/material.dart';
import 'dart:convert'; // Import for jsonDecode
import 'organization_profile_screen.dart';
import 'organization_home_screen.dart'; // Import the OrganizationHomeScreen
import 'package:vollify_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the ApiService

class OrganizationSignUpScreen extends StatefulWidget {
  const OrganizationSignUpScreen({Key? key}) : super(key: key);

  @override
  _OrganizationSignUpScreenState createState() =>
      _OrganizationSignUpScreenState();
}

class _OrganizationSignUpScreenState extends State<OrganizationSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _socialMediaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ApiService _apiService = ApiService();
  // Removed unused _organizationNameController
  bool _isLoading = false; // Loading indicator

  void _handleOrganizationSignup() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if the form is invalid
    }

    if (_emailController.text.isEmpty) {
      _showError('Email address is required.');
      return;
    } else if (!RegExp(
      r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$",
    ).hasMatch(_emailController.text)) {
      _showError('Enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Call the organizationSignup method from ApiService
      final response = await _apiService.organizationSignup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _phoneController.text.trim(),
        _locationController.text.trim(),
        _socialMediaController.text.trim(),
      );

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final userId = responseData['userId'];
        final userType = responseData['userType'];

        // Save user data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', userId.toString());
        await prefs.setString('userType', userType);

        // Navigate to the Organization Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OrganizationHomeScreen(),
          ),
        );
      } else {
        // Handle API errors
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? 'Signup failed');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      _showError('An error occurred: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // ignore: unused_element
  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Sign Up'),
        backgroundColor: const Color(0xFF20331B),
        titleTextStyle: const TextStyle(
          color: Colors.white, // Set text color to white
          fontSize: 20, // Optional: Adjust font size if needed
          fontWeight: FontWeight.bold, // Optional: Adjust font weight if needed
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _socialMediaController,
                decoration: const InputDecoration(
                  labelText: 'Social Media',
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your social media link';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E653D),
                  ),
                  onPressed: _isLoading ? null : _handleOrganizationSignup,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _socialMediaController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

String? validateEmail(String email) {
  if (email.isEmpty) {
    return 'Email address is required.';
  } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null; // Return null if validation passes
}

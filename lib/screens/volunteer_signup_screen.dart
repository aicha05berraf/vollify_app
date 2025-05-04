import 'package:flutter/material.dart';
import 'dart:convert'; // Import for jsonDecode
import 'volunteer_profile_screen.dart';
import 'volunteer_home_screen.dart'; // Import the VolunteerHomeScreen
import 'package:vollify_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the ApiService

class VolunteerSignupScreen extends StatefulWidget {
  const VolunteerSignupScreen({super.key});

  @override
  _VolunteerSignupScreenState createState() => _VolunteerSignupScreenState();
}

class _VolunteerSignupScreenState extends State<VolunteerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false; // Loading indicator

  void _handleVolunteerSignup() async {
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
      // Call the volunteerSignup method from ApiService
      final response = await _apiService.volunteerSignup(
        username: '${_firstNameController.text} ${_lastNameController.text}',
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        skills: _skillsController.text.split(',').map((s) => s.trim()).toList(),
        experience: _experienceController.text,
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

        // Navigate to the Volunteer Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VolunteerHomeScreen()),
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
        title: const Text('Volunteer Sign Up'),
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
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
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
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
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
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills (comma separated)',
                  prefixIcon: Icon(Icons.build),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your skills';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Experience',
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your experience';
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
                  onPressed: _isLoading ? null : _handleVolunteerSignup,
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
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

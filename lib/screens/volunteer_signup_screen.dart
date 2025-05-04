import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:vollify_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'volunteer_home_screen.dart';

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
  bool _isLoading = false;

  void _handleVolunteerSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.volunteerSignup(
        username: '${_firstNameController.text} ${_lastNameController.text}',
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        skills: _skillsController.text.split(',').map((s) => s.trim()).toList(),
        experience: _experienceController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final userId = responseData['userId'];
        final userType = responseData['userType'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', userId.toString());
        await prefs.setString('userType', userType);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VolunteerHomeScreen()),
        );
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? 'Signup failed');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Volunteer Sign Up'),
        backgroundColor: const Color(0xFF20331B),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: Image.asset(
                  'assets/icon/volunteer_signup.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_firstNameController, 'First Name', Icons.person),
              const SizedBox(height: 20),
              _buildTextField(_lastNameController, 'Last Name', Icons.person),
              const SizedBox(height: 20),
              _buildTextField(_emailController, 'Email', Icons.email),
              const SizedBox(height: 20),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone),
              const SizedBox(height: 20),
              _buildTextField(
                _skillsController,
                'Skills (comma separated)',
                Icons.build,
              ),
              const SizedBox(height: 20),
              _buildTextField(_experienceController, 'Experience', Icons.work),
              const SizedBox(height: 20),
              _buildPasswordField(_passwordController, 'Password'),
              const SizedBox(height: 20),
              _buildConfirmPasswordField(),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'Please enter your $label'
                  : null,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a password';
        if (value.length < 6)
          return 'Password must be at least 6 characters long';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Please confirm your password';
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
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

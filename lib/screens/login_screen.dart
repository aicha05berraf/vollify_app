import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vollify_app/screens/volunteer_home_screen.dart';
import 'package:vollify_app/screens/organization_home_screen.dart';
import 'package:vollify_app/screens/forgot_password_screen.dart';
import 'package:vollify_app/services/api_service.dart';
import 'package:vollify_app/utils/constants.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => const LoginScreen(),
      '/volunteerHome': (context) => const VolunteerHomeScreen(),
      '/organizationHome': (context) => const OrganizationHomeScreen(),
    },
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'volunteer'; // Default role

  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white), // White title text
        ),
        backgroundColor: const Color(0xFF20331B), // Dark green background
        centerTitle: false, // Align the title to the left
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login Image
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icon/login.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Welcome Back Text
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20331B),
                  ),
                ),

                const SizedBox(height: 40),

                // Email TextField
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password TextField
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Role Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: ['volunteer', 'organization'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.capitalize()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4E653D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),

                const SizedBox(height: 16),

                // Already have an account? Login
                TextButton(
                  onPressed: () {
                    final String userType = 'volunteer'; // Replace with actual logic

                    if (userType == 'volunteer') {
                      Navigator.of(context).pushReplacementNamed('/volunteerHome');
                    } else if (userType == 'organization') {
                      Navigator.of(context).pushReplacementNamed('/organizationHome');
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: const Color(0xFF1A4D2E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Replace with actual API call for login
      final response = await _apiService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', responseData['userId'].toString());
        await prefs.setString('userType', responseData['userType']);
        await prefs.setString('token', responseData['token']);

        if (responseData['userType'] == 'volunteer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const VolunteerHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrganizationHomeScreen()),
          );
        }
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('An error occurred: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

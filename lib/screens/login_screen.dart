import 'package:flutter/material.dart';
import 'package:vollify_app/screens/volunteer_profile_screen.dart';
import 'package:vollify_app/screens/forgot_password_screen.dart'; // Import the ForgotPasswordScreen
import 'package:vollify_app/utils/constants.dart';
import 'package:vollify_app/screens/volunteer_home_screen.dart';
import 'package:vollify_app/screens/organization_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String userType = ''; // Placeholder for user type

  @override
  void initState() {
    super.initState();
    _initializeUserType();
  }

  Future<void> _initializeUserType() async {
    userType = await AuthService.getUserType(); // Mock API call
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
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
                  obscureText: _obscurePassword,
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Mock login delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Mock user type (In a real app, this would come from authentication logic)
    final String userType = 'volunteer'; // Change to 'organization' for testing

    // Navigate to the appropriate home screen based on user type
    if (userType == 'volunteer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VolunteerHomeScreen(),
        ),
      );
    } else if (userType == 'organization') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrganizationHomeScreen(),
        ),
      );
    }
  }

  void someFunction() async {
    await someAsyncOperation();
  }

  Future<void> someAsyncOperation() async {
    // Add your async operation logic here
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class AuthService {
  static getUserType() {}
}

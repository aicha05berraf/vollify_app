import 'package:flutter/material.dart';
import 'package:vollify_app/utils/constants.dart';
import 'package:vollify_app/services/api_service.dart';
import 'dart:convert';

class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _volunteersNeededController =
      TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post New Opportunity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Opportunity Title',
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _volunteersNeededController,
                decoration: const InputDecoration(
                  labelText: 'Volunteers Needed',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Required Skills',
                  hintText: 'Separate with commas',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactEmailController,
                decoration: const InputDecoration(labelText: 'Contact Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactPhoneController,
                decoration: const InputDecoration(labelText: 'Contact Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handlePostOpportunity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: Colors.white, // Set text color to white
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                        : const Text('Post Opportunity'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePostOpportunity() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if the form is invalid
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Prepare the data to send to the API
      final opportunityData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'volunteersNeeded': int.tryParse(_volunteersNeededController.text) ?? 0,
        'skillsRequired':
            _skillsController.text.split(',').map((s) => s.trim()).toList(),
        'contactEmail': _contactEmailController.text.trim(),
        'contactPhone': _contactPhoneController.text.trim(),
      };

      // Call the postOpportunity method from ApiService
      final response = await _apiService.createOpportunity(
        opportunityData: opportunityData,
      );

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opportunity posted successfully!')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        final responseData = jsonDecode(response.body);
        _showError(responseData['message'] ?? 'Failed to post opportunity.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      _showError('An error occurred: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

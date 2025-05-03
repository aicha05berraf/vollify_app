import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vollify_app/models/user_model.dart';
import 'package:vollify_app/widgets/profile_image_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vollify_app/services/api_service.dart'; // if not already

class VolunteerProfileScreen extends StatefulWidget {
  const VolunteerProfileScreen({super.key});

  @override
  State<VolunteerProfileScreen> createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends State<VolunteerProfileScreen> {
  late Volunteer _volunteer;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _skillsController;
  late TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    _initializeControllers(); // set empty controllers first
    _fetchVolunteerProfile(); // fetch from API
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: _volunteer.name);
    _lastNameController = TextEditingController(text: _volunteer.lastName);
    _emailController = TextEditingController(text: _volunteer.email);
    _phoneController = TextEditingController(text: _volunteer.phone);
    _skillsController = TextEditingController(
      text: _volunteer.skills.join(', '),
    );
    _experienceController = TextEditingController(text: _volunteer.experience);
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      _showError('Failed to pick image: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final volunteerId = prefs.getInt('userId');

      if (volunteerId == null) {
        _showError('User ID not found.');
        return;
      }

      String? base64Image;
      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final updatedData = {
        'name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'skills':
            _skillsController.text.split(',').map((s) => s.trim()).toList(),
        'experience': _experienceController.text,
        'image': base64Image,
      };

      final response = await ApiService().updateVolunteerProfile(
        int.parse(_volunteer.id),
        updatedData,
      );

      if (response.statusCode == 200) {
        setState(() {
          _volunteer = Volunteer(
            id: _volunteer.id,
            name: updatedData['name'] as String,
            lastName: updatedData['last_name'] as String,
            email: updatedData['email'] as String,
            phone: updatedData['phone'] as String,
            skills: List<String>.from(updatedData['skills'] as List),
            experience: updatedData['experience'] as String,
            imageUrl:
                _volunteer
                    .imageUrl, // Keep current imageUrl or update from response
          );
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? 'Failed to update profile.');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/userType', // Navigate to the user type screen
                  (route) => false, // Remove all previous routes
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchVolunteerProfile() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final volunteerId = prefs.getInt(
        'userId',
      ); // Ensure this is stored at login

      if (volunteerId == null) {
        _showError('User ID not found.');
        return;
      }

      final response = await ApiService().getVolunteerProfile(volunteerId);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _volunteer = Volunteer(
            id: data['id'].toString(),
            name: data['name'] ?? '',
            lastName: data['last_name'] ?? '',
            email: data['email'] ?? '',
            phone: data['phone'] ?? '',
            skills: List<String>.from(data['skills'] ?? []),
            experience: data['experience'] ?? '',
            imageUrl: data['image_url'],
          );

          _firstNameController.text = _volunteer.name;
          _lastNameController.text = _volunteer.lastName;
          _emailController.text = _volunteer.email;
          _phoneController.text = _volunteer.phone;
          _skillsController.text = _volunteer.skills.join(', ');
          _experienceController.text = _volunteer.experience;
        });
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? 'Failed to load profile.');
      }
    } catch (e) {
      _showError('Error fetching profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildViewMode() {
    return Column(
      children: [
        ProfileImageEditor(
          imageFile: _imageFile,
          onPickImage: _pickImage,
          isEditing: _isEditing,
          radius: 80,
        ),
        const SizedBox(height: 16),
        Text(
          '${_volunteer.name} ${_volunteer.lastName}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Chip(
          label: const Text('Volunteer'),
          backgroundColor: Colors.green[100],
        ),
        const SizedBox(height: 24),
        _buildInfoCard('Skills', _volunteer.skills.join(', '), Icons.star),
        _buildInfoCard('Experience', _volunteer.experience, Icons.work),
        _buildInfoCard('Email', _volunteer.email, Icons.email),
        _buildInfoCard('Phone', _volunteer.phone, Icons.phone),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildEditMode() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileImageEditor(
              imageFile: _imageFile,
              onPickImage: _pickImage,
              isEditing: true,
              radius: 80,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator:
                  (value) => !value!.contains('@') ? 'Invalid email' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (value) => value!.length < 8 ? 'Too short' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills',
                hintText: 'Separate with commas',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(labelText: 'Experience'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              if (!_isLoading) {
                setState(() => _isEditing = !_isEditing);
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ), // Set icon color to red
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: _isEditing ? _buildEditMode() : _buildViewMode(),
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
    super.dispose();
  }
}

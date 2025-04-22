import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vollify_app/models/user_model.dart';
import 'package:vollify_app/widgets/profile_image_editor.dart';

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
    _volunteer = Volunteer(
      id: '1',
      name: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phone: '+1 234 567 890',
      skills: ['Teaching', 'First Aid', 'Cooking'],
      experience: '5 years volunteering',
    );

    _initializeControllers();
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;

        _volunteer = Volunteer(
          id: _volunteer.id,
          name: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          skills:
              _skillsController.text.split(',').map((s) => s.trim()).toList(),
          experience: _experienceController.text,
          imageUrl: _imageFile != null ? _imageFile!.path : _volunteer.imageUrl,
        );

        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
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
            ),
          ],
        );
      },
    );
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
            icon: const Icon(Icons.logout, color: Colors.red), // Set icon color to red
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

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vollify_app/models/user_model.dart';
import 'package:vollify_app/utils/constants.dart';
import 'package:vollify_app/widgets/profile_info_card.dart';
import 'package:vollify_app/widgets/clickable_info_card.dart';

class OrganizationProfileScreen extends StatefulWidget {
  const OrganizationProfileScreen({Key? key}) : super(key: key);

  @override
  _OrganizationProfileScreenState createState() =>
      _OrganizationProfileScreenState();
}

class _OrganizationProfileScreenState extends State<OrganizationProfileScreen> {
  late Organization _organization;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _socialMediaController;

  @override
  void initState() {
    super.initState();
    _organization = Organization(
      id: '1',
      email: 'contact@greenearth.org',
      phone: '+1 234 567 890',
      name: 'Green Earth Initiative',
      location: '123 Green St, Eco City',
      socialMedia: [
        'https://twitter.com/greenearth',
        'https://instagram.com/greenearth',
      ],
    );

    _nameController = TextEditingController(text: _organization.name);
    _emailController = TextEditingController(text: _organization.email);
    _phoneController = TextEditingController(text: _organization.phone);
    _locationController = TextEditingController(text: _organization.location);
    _socialMediaController = TextEditingController(
      text: _organization.socialMedia.join('\n'),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _organization = Organization(
          id: _organization.id,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          location: _locationController.text,
          socialMedia: _socialMediaController.text.split('\n'),
        );
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _isEditing ? _pickImage : null,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                _imageFile != null
                    ? FileImage(_imageFile!)
                    : const AssetImage('assets/default_org.png')
                        as ImageProvider,
            child:
                _imageFile == null
                    ? const Icon(Icons.business, size: 40, color: Colors.white)
                    : null,
          ),
          if (_isEditing)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildProfileImage(),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Organization Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value!.isEmpty ? 'Required field' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator:
                (value) => value!.contains('@') ? null : 'Enter a valid email',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator:
                (value) => value!.length >= 8 ? null : 'Enter valid phone',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value!.isEmpty ? 'Required field' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _socialMediaController,
            decoration: const InputDecoration(
              labelText: 'Social Media (one per line)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            child:
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfileImage(),
        const SizedBox(height: 16),
        ProfileInfoCard(
          icon: Icons.business,
          title: 'Organization Name',
          value: _organization.name,
        ),
        ProfileInfoCard(
          icon: Icons.email,
          title: 'Email',
          value: _organization.email,
        ),
        ProfileInfoCard(
          icon: Icons.phone,
          title: 'Phone',
          value: _organization.phone,
        ),
        ProfileInfoCard(
          icon: Icons.location_on,
          title: 'Location',
          value: _organization.location,
        ),

        ..._organization.socialMedia.map(
          (link) => ClickableInfoCard(
            icon: FontAwesomeIcons.link,
            title: 'Social Media',
            value: link,
            onTap: () => launchUrl(Uri.parse(link)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _isEditing ? _buildEditMode() : _buildViewMode(),
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
    super.dispose();
  }
}

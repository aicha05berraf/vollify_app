import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileImageEditor extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPickImage;
  final bool isEditing;
  final bool isOrganization;
  final double radius;

  const ProfileImageEditor({
    super.key,
    required this.imageFile,
    required this.onPickImage,
    required this.isEditing,
    this.isOrganization = false,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditing ? onPickImage : null,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                imageFile != null
                    ? FileImage(imageFile!)
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
            child:
                imageFile == null
                    ? Icon(
                      isOrganization ? Icons.business : Icons.person,
                      size: radius * 0.6,
                      color: Colors.white,
                    )
                    : null,
          ),
          if (isEditing)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                size: radius * 0.25,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}

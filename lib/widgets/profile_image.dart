import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileImage extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onEditPressed;
  final double radius;
  final bool isOrganization;

  const ProfileImage({
    super.key,
    this.imageFile,
    required this.onEditPressed,
    this.radius = 60,
    this.isOrganization = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
          child:
              imageFile == null
                  ? Icon(
                    isOrganization ? Icons.business : Icons.person,
                    size: radius,
                  )
                  : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4E653D),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: onEditPressed,
            ),
          ),
        ),
      ],
    );
  }
}

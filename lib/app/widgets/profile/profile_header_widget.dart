import 'dart:io';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String? profileImageUrl;
  final File? imageFile;
  final String userName;
  final String userEmail;
  final VoidCallback onImageTap;


  const ProfileHeaderWidget({
    super.key,
    required this.profileImageUrl,
    this.imageFile,
    required this.userName,
    required this.userEmail,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onImageTap,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: imageFile != null 
                    ? FileImage(imageFile!) as ImageProvider
                    : profileImageUrl != null 
                        ? NetworkImage(profileImageUrl!) 
                        : null,
                child: profileImageUrl == null && imageFile == null
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

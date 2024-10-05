import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onTap;
  final bool enabled;

  const ProfileImagePicker({
    Key? key,
    this.imageUrl,
    required this.onTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
        backgroundImage: _getImageProvider(),
        child: enabled
            ? Icon(
                imageUrl != null ? Icons.edit : Icons.camera_alt,
                color: AppConstants.primaryColor,
              )
            : null,
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return null;
  }
}
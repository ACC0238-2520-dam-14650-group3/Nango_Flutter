import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/views/home_view.dart';

class ProfileValidationView extends StatefulWidget {
  final String userType;

  const ProfileValidationView({
    super.key,
    required this.userType,
  });

  @override
  State<ProfileValidationView> createState() => _ProfileValidationViewState();
}

class _ProfileValidationViewState extends State<ProfileValidationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Profile Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                'Welcome, we\'d like you to add your details to verify\nyour profile as a ${widget.userType.toLowerCase()}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 32),
              // Profile photo
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.tertiaryText,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.backgroundLight,
                          border: Border.all(
                            color: AppColors.tertiaryText,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // DNI field
              _buildInfoRow(
                label: 'DNI',
                value: '',
                hasUpload: true,
              ),
              const Divider(height: 24),
              // Email field
              _buildInfoRow(
                label: 'Email',
                value: 'junior245@gmail.com',
                hasUpload: false,
              ),
              const Divider(height: 24),
              // Phone Number field
              _buildInfoRow(
                label: 'Phone Number',
                value: '999493821',
                hasUpload: false,
              ),
              const Divider(height: 24),
              // Plan field
              _buildInfoRow(
                label: 'Plan',
                value: 'Premium',
                hasUpload: false,
              ),
              const Divider(height: 24),
              // University ID field
              _buildInfoRow(
                label: 'University ID',
                value: '',
                hasUpload: true,
              ),
              const SizedBox(height: 48),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondaryText,
                          side: BorderSide(
                            color: AppColors.tertiaryText,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool hasUpload,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '' : value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryText,
            ),
          ),
        ),
        if (hasUpload)
          GestureDetector(
            onTap: () {
              // Handle document upload
            },
            child: Row(
              children: [
                Icon(
                  Icons.upload_file,
                  size: 20,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(width: 4),
                Text(
                  'Upload document',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.secondaryText,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
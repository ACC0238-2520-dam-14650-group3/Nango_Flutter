import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';

class AccountSupportView extends StatelessWidget {
  const AccountSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  'Support',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Support options
              _buildSupportOption(
                context,
                icon: Icons.warning_amber_outlined,
                title: 'Issues with the app',
                description:
                    'Is something not working properly? Report it here so we can help you quickly.',
                onTap: () {
                  // Handle issues reporting
                  _showComingSoonDialog(context, 'Issue Reporting');
                },
              ),
              const SizedBox(height: 16),
              _buildSupportOption(
                context,
                icon: Icons.support_agent_outlined,
                title: 'Technical support',
                description:
                    'Do you have questions about how to use NanGo? Access our FAQs or chat with support agent.',
                onTap: () {
                  // Handle technical support
                  _showComingSoonDialog(context, 'Technical Support');
                },
              ),
              const SizedBox(height: 16),
              _buildSupportOption(
                context,
                icon: Icons.phone_outlined,
                title: 'Hotline',
                description:
                    'If you need urgent help, call our support number directly.',
                onTap: () {
                  // Handle hotline call
                  _showComingSoonDialog(context, 'Hotline');
                },
              ),
              const SizedBox(height: 16),
              _buildSupportOption(
                context,
                icon: Icons.email_outlined,
                title: 'Contact us by email',
                description:
                    'You can also send us your questions or suggestion via email.',
                onTap: () {
                  // Handle email contact
                  _showComingSoonDialog(context, 'Email Contact');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.secondaryText.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primaryText,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primaryText,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
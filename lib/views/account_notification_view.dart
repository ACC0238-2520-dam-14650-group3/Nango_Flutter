import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/services/preferences_service.dart';

class AccountNotificationView extends StatefulWidget {
  const AccountNotificationView({super.key});

  @override
  State<AccountNotificationView> createState() =>
      _AccountNotificationViewState();
}

class _AccountNotificationViewState extends State<AccountNotificationView> {
  late PreferencesService _prefsService;
  bool _isLoading = true;

  // Notification settings
  bool _notificationBadge = true;
  bool _notificationRoutes = true;
  bool _notificationRequest = false;
  bool _notificationChat = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefsService = await PreferencesService.getInstance();
    setState(() {
      _notificationBadge = _prefsService.getNotificationBadge();
      _notificationRoutes = _prefsService.getNotificationRoutes();
      _notificationRequest = _prefsService.getNotificationRequest();
      _notificationChat = _prefsService.getNotificationChat();
      _isLoading = false;
    });
  }

  Future<void> _saveNotificationBadge(bool value) async {
    await _prefsService.setNotificationBadge(value);
    setState(() {
      _notificationBadge = value;
    });
  }

  Future<void> _saveNotificationRoutes(bool value) async {
    await _prefsService.setNotificationRoutes(value);
    setState(() {
      _notificationRoutes = value;
    });
  }

  Future<void> _saveNotificationRequest(bool value) async {
    await _prefsService.setNotificationRequest(value);
    setState(() {
      _notificationRequest = value;
    });
  }

  Future<void> _saveNotificationChat(bool value) async {
    await _prefsService.setNotificationChat(value);
    setState(() {
      _notificationChat = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  'Notifications',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Notification Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification badge',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Display a badge with the number of\nunread notifications',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _notificationBadge,
                    onChanged: _saveNotificationBadge,
                    activeThumbColor: AppColors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Push notifications header
              Text(
                'Push notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 16),
              // Routes
              _buildNotificationCheckbox(
                label: 'Routes',
                value: _notificationRoutes,
                onChanged: _saveNotificationRoutes,
              ),
              const SizedBox(height: 16),
              // Request
              _buildNotificationCheckbox(
                label: 'Request',
                value: _notificationRequest,
                onChanged: _saveNotificationRequest,
              ),
              const SizedBox(height: 16),
              // Chat
              _buildNotificationCheckbox(
                label: 'Chat',
                value: _notificationChat,
                onChanged: _saveNotificationChat,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCheckbox({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.primaryText,
          ),
        ),
        Checkbox(
          value: value,
          onChanged: (newValue) => onChanged(newValue ?? false),
          activeColor: AppColors.secondaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
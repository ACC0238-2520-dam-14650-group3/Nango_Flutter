import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/services/preferences_service.dart';

class AccountLanguageView extends StatefulWidget {
  const AccountLanguageView({super.key});

  @override
  State<AccountLanguageView> createState() => _AccountLanguageViewState();
}

class _AccountLanguageViewState extends State<AccountLanguageView> {
  late PreferencesService _prefsService;
  bool _isLoading = true;
  String _selectedLanguage = 'en';

  final Map<String, String> _languages = {
    'es': 'Español',
    'en': 'English',
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefsService = await PreferencesService.getInstance();
    setState(() {
      _selectedLanguage = _prefsService.getLanguage();
      _isLoading = false;
    });
  }

  Future<void> _saveLanguage(String language) async {
    await _prefsService.setLanguage(language);
    setState(() {
      _selectedLanguage = language;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to ${_languages[language]}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                  'Language',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Language options
              _buildLanguageOption(
                code: 'es',
                label: '(ES)    Español',
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                code: 'en',
                label: '(EN)    English',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String code,
    required String label,
  }) {
    final isSelected = _selectedLanguage == code;

    return GestureDetector(
      onTap: () => _saveLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.secondaryText
                : AppColors.secondaryText.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                if (value == true) {
                  _saveLanguage(code);
                }
              },
              activeColor: AppColors.secondaryText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
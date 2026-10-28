import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/language_provider.dart';
import '../main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailPhoneController = TextEditingController(
    text: 'aarav.patel@saathiapp.org',
  );
  final _passwordController = TextEditingController(text: 'password123');
  String _selectedCity = 'Ahmedabad';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final langProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Requirement 18: Language Selector Bar on Login Screen
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.language,
                    size: 18,
                    color: AppColors.trustTeal,
                  ),
                  const SizedBox(width: 4),
                  _langChip('en', 'English', langProvider),
                  const SizedBox(width: 4),
                  _langChip('gu', 'ગુજરાતી', langProvider),
                  const SizedBox(width: 4),
                  _langChip('hi', 'हिन्दी', langProvider),
                ],
              ),
              const SizedBox(height: 12),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.trustTeal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.handshake_rounded,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  loc.translate('appName'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepForest,
                  ),
                ),
              ),
              Center(
                child: Text(
                  loc.translate('tagline'),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              // Quick Account Selector Toggles for Testing
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.softMint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Login Selector:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepForest,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        ActionChip(
                          label: const Text('Aarav (Member)'),
                          backgroundColor: AppColors.white,
                          onPressed: () {
                            setState(() {
                              _emailPhoneController.text =
                                  'aarav.patel@saathiapp.org';
                              _selectedCity = 'Ahmedabad';
                            });
                          },
                        ),
                        ActionChip(
                          label: const Text('Meera (Verified)'),
                          backgroundColor: AppColors.white,
                          onPressed: () {
                            setState(() {
                              _emailPhoneController.text =
                                  'meera@charitycare.org';
                              _selectedCity = 'Ahmedabad';
                            });
                          },
                        ),
                        ActionChip(
                          label: const Text('Rajesh (Surat)'),
                          backgroundColor: AppColors.white,
                          onPressed: () {
                            setState(() {
                              _emailPhoneController.text =
                                  'rajesh@suratcare.org';
                              _selectedCity = 'Surat';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Input Form
              TextField(
                controller: _emailPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Email Address / Mobile Number',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Preferred City Selector
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                decoration: InputDecoration(
                  labelText: loc.translate('registeredCity'),
                  prefixIcon: const Icon(Icons.location_city),
                ),
                items: AppConstants.supportedCities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCity = val);
                },
              ),
              const SizedBox(height: 24),

              AppButton(
                label: 'Sign In to SaathiApp',
                width: double.infinity,
                isLoading: _isLoading,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  setState(() => _isLoading = true);
                  await authProvider.login(
                    _emailPhoneController.text,
                    _passwordController.text,
                  );
                  await authProvider.setRegisteredCity(_selectedCity);
                  cityProvider.setCity(_selectedCity);
                  if (mounted) {
                    setState(() => _isLoading = false);
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    authProvider.login('guest@saathiapp.org', 'pass');
                    cityProvider.setCity('Ahmedabad');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen(),
                      ),
                    );
                  },
                  child: const Text('Continue as Guest Member'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _langChip(String code, String label, LanguageProvider langProvider) {
    final isSelected = langProvider.locale.languageCode == code;
    return GestureDetector(
      onTap: () => langProvider.changeLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.trustTeal : AppColors.softMint,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? AppColors.white : AppColors.deepForest,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

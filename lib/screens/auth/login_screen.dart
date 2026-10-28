import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
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

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
              const Center(
                child: Text(
                  'Welcome to SaathiApp',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepForest,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'One account to request help and offer help in your city.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Quick Account Selector Toggles for Demo
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
                          label: const Text('Admin Support'),
                          backgroundColor: AppColors.white,
                          onPressed: () {
                            setState(() {
                              _emailPhoneController.text =
                                  'admin@saathiapp.org';
                              _selectedCity = 'Ahmedabad';
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

              // City Selector
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(
                  labelText: 'Registered City',
                  prefixIcon: Icon(Icons.location_city),
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
                  setState(() => _isLoading = true);
                  await authProvider.login(
                    _emailPhoneController.text,
                    _passwordController.text,
                  );
                  await authProvider.setRegisteredCity(_selectedCity);
                  cityProvider.setCity(_selectedCity);
                  setState(() => _isLoading = false);

                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
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
                    // Quick guest access
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
}

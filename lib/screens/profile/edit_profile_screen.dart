import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/post_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late String _preferredCity;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    final cityProvider = Provider.of<CityProvider>(context, listen: false);

    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _preferredCity = user?.registeredCity ?? cityProvider.selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Edit Account Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name *'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Mobile Number *'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address *'),
            ),
            const SizedBox(height: 16),

            // Preferred City Dropdown Selector (Requirement 15)
            DropdownButtonFormField<String>(
              initialValue: _preferredCity,
              decoration: const InputDecoration(
                labelText: 'Registered Preferred City *',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: AppConstants.supportedCities.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _preferredCity = val);
              },
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Save Changes',
              width: double.infinity,
              isLoading: _isSaving,
              onPressed: () async {
                if (user == null) return;
                final messenger = ScaffoldMessenger.of(context);
                final nav = Navigator.of(context);

                setState(() => _isSaving = true);

                final updated = user.copyWith(
                  name: _nameController.text.trim(),
                  phone: _phoneController.text.trim(),
                  email: _emailController.text.trim(),
                  registeredCity: _preferredCity,
                );

                // Requirement 15: Save preferred city & refresh Home feed
                await authProvider.updateProfile(updated);
                await authProvider.setRegisteredCity(_preferredCity);
                cityProvider.setCity(_preferredCity);
                await postProvider.fetchHomePosts(
                  preferredCity: _preferredCity,
                );

                if (mounted) {
                  setState(() => _isSaving = false);
                  nav.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profile & preferred city updated to $_preferredCity!',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

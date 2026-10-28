import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/category_provider.dart';
import '../../data/models/post_model.dart';
import 'location_picker_screen.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _areaController = TextEditingController();
  final _durationController = TextEditingController(
    text: 'Available until fulfilled',
  );
  final _contactController = TextEditingController();

  String _selectedCategoryId = 'cat_food';
  late String _selectedUnit;
  bool _agreeToTerms = true;
  bool _isSubmitting = false;
  final List<String> _mediaUrls = [];

  @override
  void initState() {
    super.initState();
    _selectedUnit = AppConstants.getDefaultUnitForCategory(_selectedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final loc = AppLocalizations.of(context);

    final preferredCity = cityProvider.selectedCity;
    final availableUnits =
        AppConstants.categoryUnits[_selectedCategoryId] ?? ['items'];

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Offer Assistance (Step 1 of 2)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Offer Title *',
                  hintText: 'e.g., 10 Fresh Cooked Food Packets in Navrangpura',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Service Category *',
                ),
                items: categoryProvider.categories.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategoryId = val;
                      _selectedUnit = AppConstants.getDefaultUnitForCategory(
                        val,
                      );
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description of Offer *',
                  hintText: 'Describe what you are offering, condition, pickup/delivery details.',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Description required'
                    : null,
              ),
              const SizedBox(height: 16),

              // Quantity & Category Unit Row (Requirement 6)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                      ),
                      validator: (val) =>
                          val == null ||
                              int.tryParse(val) == null ||
                              int.parse(val) <= 0
                          ? 'Valid quantity'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: availableUnits.contains(_selectedUnit)
                          ? _selectedUnit
                          : availableUnits.first,
                      decoration: const InputDecoration(
                        labelText: 'Quantity Unit *',
                      ),
                      items: availableUnits.map((u) {
                        return DropdownMenuItem(value: u, child: Text(u));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedUnit = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area / Landmark ($preferredCity) *',
                  hintText: 'e.g., Commerce Six Roads',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Area required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Availability Duration',
                  hintText: 'e.g., Till 8 PM today / This week',
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Pickup / Fulfilment Instructions',
                  hintText: 'e.g., Pickup near Metro Station gate 2',
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Attach Photo (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_a_photo, size: 18),
                    label: const Text('Add Photo'),
                    onPressed: _pickPhoto,
                  ),
                ],
              ),
              if (_mediaUrls.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: _mediaUrls.map((url) {
                    return Chip(
                      label: const Text('Photo Attached'),
                      onDeleted: () => setState(() => _mediaUrls.remove(url)),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _agreeToTerms,
                title: const Text(
                  'I confirm these items/services are available free of charge as community aid.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                onChanged: (val) => setState(() => _agreeToTerms = val ?? true),
              ),
              const SizedBox(height: 20),

              // Step 1 Next Button -> Step 2 Location Picker (Requirement 7)
              AppButton(
                label: loc.translate('next'),
                width: double.infinity,
                variant: AppButtonVariant.primary,
                isLoading: _isSubmitting,
                onPressed: _proceedToLocationPicker,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _mediaUrls.add(file.path));
    }
  }

  Future<void> _proceedToLocationPicker() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms) return;

    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final loc = AppLocalizations.of(context);

    final locationResult = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialCity: cityProvider.selectedCity,
          initialArea: _areaController.text.trim(),
          submitButtonLabel: loc.translate('publishAssistanceOffer'),
        ),
      ),
    );

    if (locationResult != null) {
      await _finalSubmitOffer(locationResult);
    }
  }

  Future<void> _finalSubmitOffer(Map<String, dynamic> locationData) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final user = authProvider.currentUser;
    final city = locationData['city'] as String? ?? cityProvider.selectedCity;
    final areaName =
        locationData['areaName'] as String? ?? _areaController.text.trim();
    final lat = locationData['latitude'] as double?;
    final lng = locationData['longitude'] as double?;

    final qty = int.tryParse(_quantityController.text) ?? 1;

    final cat = categoryProvider.categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categoryProvider.categories.first,
    );

    setState(() => _isSubmitting = true);

    final newPost = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.id ?? 'user_guest',
      userName: user?.name ?? 'Community Helper',
      userAvatar: user?.avatarUrl ?? '',
      userIsVerified: user?.isVerified ?? false,
      type: 'offer',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      categoryId: cat.id,
      categoryName: cat.name,
      priority: 'normal',
      totalQuantity: qty,
      remainingQuantity: qty,
      quantityUnit: _selectedUnit,
      city: city,
      areaName: areaName,
      latitude: lat,
      longitude: lng,
      durationText: _durationController.text.trim(),
      contactInstructions: _contactController.text.trim(),
      mediaUrls: _mediaUrls,
      createdAt: DateTime.now().toIso8601String().split('.').first,
    );

    await postProvider.createPost(newPost, cityProvider.selectedCity);
    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assistance Offer published successfully!'),
        ),
      );
      Navigator.pop(context);
    }
  }
}

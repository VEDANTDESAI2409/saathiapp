import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/emergency_fallback_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/category_provider.dart';
import '../../data/models/post_model.dart';
import 'location_picker_screen.dart';

class CreateNeedScreen extends StatefulWidget {
  const CreateNeedScreen({super.key});

  @override
  State<CreateNeedScreen> createState() => _CreateNeedScreenState();
}

class _CreateNeedScreenState extends State<CreateNeedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _areaController = TextEditingController();
  final _contactController = TextEditingController();

  String _selectedCategoryId = 'cat_food';
  late String _selectedUnit;
  String _priority = 'normal';
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
    final postProvider = Provider.of<PostProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final loc = AppLocalizations.of(context);

    final monthlyUsage = postProvider.currentMonthlyUsage;
    final preferredCity = cityProvider.selectedCity;
    final availableUnits =
        AppConstants.categoryUnits[_selectedCategoryId] ?? ['items'];

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Request Help (Step 1 of 2)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Monthly Limit Warning Banner
              if (monthlyUsage != null && monthlyUsage.isLimitReached)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warmOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warmOrange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: AppColors.warmOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Monthly help limit reached (${monthlyUsage.count}/${monthlyUsage.limit}). Exception review required for high-volume requests.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.deepForest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Request Title *',
                  hintText: 'e.g., Cooked food packets required in Paldi',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 16),

              // Category Selector (Updates Quantity Unit automatically)
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

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Detailed Description *',
                  hintText: 'Explain what genuine help is needed, specific requirements, or situation.',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 16),

              // Quantity & Category-Specific Unit Selection (Requirement 6)
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

              // Initial Area / Landmark
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area / Landmark ($preferredCity) *',
                  hintText: 'e.g., Near Commerce Six Roads',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Area or landmark required'
                    : null,
              ),
              const SizedBox(height: 16),

              // Priority Level Radio Selector
              const Text(
                'Priority Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepForest,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _priorityChip('normal', 'Normal', AppColors.trustTeal),
                  const SizedBox(width: 8),
                  _priorityChip('high', 'High Priority', AppColors.warmOrange),
                  const SizedBox(width: 8),
                  _priorityChip(
                    'emergency',
                    'EMERGENCY',
                    AppColors.emergencyRed,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contact Instructions
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Safe Fulfilment Instructions',
                  hintText:
                      'e.g., Drop at security guard desk or call upon arrival',
                ),
              ),
              const SizedBox(height: 16),

              // Photo Attachment Section
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

              // Terms & Privacy Check
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _agreeToTerms,
                title: const Text(
                  'I certify that this is a genuine request for mutual community assistance.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                onChanged: (val) => setState(() => _agreeToTerms = val ?? true),
              ),
              const SizedBox(height: 20),

              // Step 1 Next Button -> Navigates to Step 2 Location Picker (Requirement 7)
              AppButton(
                label: loc.translate('next'),
                width: double.infinity,
                variant: _priority == 'emergency'
                    ? AppButtonVariant.emergency
                    : AppButtonVariant.primary,
                isLoading: _isSubmitting,
                onPressed: _proceedToLocationPicker,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityChip(String val, String label, Color color) {
    final isSelected = _priority == val;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.deepForest,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (selected) {
        if (selected) setState(() => _priority = val);
      },
    );
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _mediaUrls.add(file.path);
      });
    }
  }

  // Requirement 7: Navigation to Step 2 Location Picker and final submission
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
          submitButtonLabel: loc.translate('submitHelpRequest'),
        ),
      ),
    );

    if (locationResult != null) {
      await _finalSubmitPost(locationResult);
    }
  }

  Future<void> _finalSubmitPost(Map<String, dynamic> locationData) async {
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

    try {
      final newPost = PostModel(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        userId: user?.id ?? 'user_guest',
        userName: user?.name ?? 'Community Member',
        userAvatar: user?.avatarUrl ?? '',
        userIsVerified: user?.isVerified ?? false,
        type: 'need',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        categoryId: cat.id,
        categoryName: cat.name,
        priority: _priority,
        totalQuantity: qty,
        remainingQuantity: qty,
        quantityUnit: _selectedUnit,
        city: city,
        areaName: areaName,
        latitude: lat,
        longitude: lng,
        contactInstructions: _contactController.text.trim(),
        mediaUrls: _mediaUrls,
        createdAt: DateTime.now().toIso8601String().split('.').first,
      );

      await postProvider.createPost(newPost, cityProvider.selectedCity);
      setState(() => _isSubmitting = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Help Request published successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (_priority == 'emergency' && mounted) {
        showDialog(
          context: context,
          builder: (_) => EmergencyFallbackDialog(
            onRetry: () => _finalSubmitPost(locationData),
            onSaveDraft: () => Navigator.pop(context),
          ),
        );
      }
    }
  }
}

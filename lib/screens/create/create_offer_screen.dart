import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/category_provider.dart';
import '../../data/models/post_model.dart';

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
  bool _agreeToTerms = true;
  bool _isSubmitting = false;
  List<String> _mediaUrls = [];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final user = authProvider.currentUser;
    final city = cityProvider.selectedCity;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Offer Assistance (Offer)')),
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
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Service Category *',
                ),
                items: categoryProvider.categories.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategoryId = val);
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

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Available Capacity / Qty *',
                      ),
                      validator: (val) =>
                          val == null || int.tryParse(val) == null
                          ? 'Valid number'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      decoration: const InputDecoration(
                        labelText: 'Area / Landmark *',
                        hintText: 'e.g., Commerce Six Roads',
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Area required'
                          : null,
                    ),
                  ),
                ],
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

              AppButton(
                label: 'Publish Assistance Offer',
                width: double.infinity,
                variant: AppButtonVariant.primary,
                isLoading: _isSubmitting,
                onPressed: _submitForm,
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final user = authProvider.currentUser;
    final city = cityProvider.selectedCity;
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
      city: city,
      areaName: _areaController.text.trim(),
      durationText: _durationController.text.trim(),
      contactInstructions: _contactController.text.trim(),
      mediaUrls: _mediaUrls,
      createdAt: DateTime.now().toIso8601String().split('.').first,
    );

    await postProvider.createPost(newPost);
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

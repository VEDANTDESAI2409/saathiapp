import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/verification_provider.dart';
import '../../data/models/verification_model.dart';

class VerificationSubmissionScreen extends StatefulWidget {
  const VerificationSubmissionScreen({super.key});

  @override
  State<VerificationSubmissionScreen> createState() =>
      _VerificationSubmissionScreenState();
}

class _VerificationSubmissionScreenState
    extends State<VerificationSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _docType = 'Aadhaar Card';
  final _docNumController = TextEditingController();
  String? _frontPath;
  String? _backPath;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final verifProvider = Provider.of<VerificationProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Submit Identity Verification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Identity Verification',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepForest,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Get verified to build community trust and prioritize emergency response.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _docType,
                decoration: const InputDecoration(
                  labelText: 'Select Document Type *',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Aadhaar Card',
                    child: Text('Aadhaar Card'),
                  ),
                  DropdownMenuItem(value: 'Voter ID', child: Text('Voter ID')),
                  DropdownMenuItem(
                    value: 'Driving License',
                    child: Text('Driving License'),
                  ),
                  DropdownMenuItem(
                    value: 'Government ID',
                    child: Text('Government Issued ID'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _docType = val);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _docNumController,
                decoration: const InputDecoration(
                  labelText: 'Document Number *',
                  hintText: 'e.g., XXXX XXXX 1234',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Document number required'
                    : null,
              ),
              const SizedBox(height: 20),

              const Text(
                'Upload Document Front Photo *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepForest,
                ),
              ),
              const SizedBox(height: 8),
              _photoTile(_frontPath, () => _pickDocPhoto(isFront: true)),
              const SizedBox(height: 16),

              const Text(
                'Upload Document Back Photo (Optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepForest,
                ),
              ),
              const SizedBox(height: 8),
              _photoTile(_backPath, () => _pickDocPhoto(isFront: false)),
              const SizedBox(height: 28),

              AppButton(
                label: 'Submit for Verification Review',
                width: double.infinity,
                isLoading: verifProvider.isSubmitting,
                onPressed: () async {
                  if (!_formKey.currentState!.validate() || user == null)
                    return;

                  final sub = VerificationSubmissionModel(
                    id: 'verif_${DateTime.now().millisecondsSinceEpoch}',
                    userId: user.id,
                    userName: user.name,
                    documentType: _docType,
                    documentNumber: _docNumController.text.trim(),
                    documentFrontUrl: _frontPath ?? '',
                    documentBackUrl: _backPath ?? '',
                    submittedAt: DateTime.now()
                        .toIso8601String()
                        .split('.')
                        .first,
                  );

                  await verifProvider.submitVerification(sub);
                  await authProvider.initUser();

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Verification submitted for admin review.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoTile(String? path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: path != null
            ? const Center(
                child: Text(
                  'Document Photo Selected',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.trustTeal,
                  ),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: AppColors.trustTeal),
                  SizedBox(width: 8),
                  Text(
                    'Tap to select photo',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickDocPhoto({required bool isFront}) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        if (isFront) {
          _frontPath = file.path;
        } else {
          _backPath = file.path;
        }
      });
    }
  }
}

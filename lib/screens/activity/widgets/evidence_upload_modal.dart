import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/reservation_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/post_provider.dart';
import '../../../providers/city_provider.dart';

class EvidenceUploadModal extends StatefulWidget {
  final ReservationModel reservation;

  const EvidenceUploadModal({super.key, required this.reservation});

  @override
  State<EvidenceUploadModal> createState() => _EvidenceUploadModalState();
}

class _EvidenceUploadModalState extends State<EvidenceUploadModal> {
  String? _imagePath;
  final TextEditingController _descController = TextEditingController();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);

    final user = authProvider.currentUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Fulfilment Evidence *',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.deepForest,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mandatory photo proof for "${widget.reservation.postTitle}".',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.softMint,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _imagePath != null
                      ? AppColors.trustTeal
                      : AppColors.border,
                  width: _imagePath != null ? 2 : 1,
                ),
              ),
              child: _imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.trustTeal,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Photo Attached Ready for Submission',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.trustTeal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 36,
                          color: AppColors.trustTeal,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap to capture / select photo *',
                          style: TextStyle(
                            color: AppColors.trustTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Notes / Description (Optional)',
              hintText: 'e.g., Handed over ration packets at community center.',
            ),
          ),
          const SizedBox(height: 24),

          AppButton(
            label: 'Submit Evidence & Complete Help',
            width: double.infinity,
            isLoading: _isUploading,
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              if (_imagePath == null || _imagePath!.trim().isEmpty) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Photo evidence is required to complete this assistance.',
                    ),
                    backgroundColor: AppColors.emergencyRed,
                  ),
                );
                return;
              }

              if (user == null) return;

              setState(() => _isUploading = true);

              try {
                await postProvider.completeReservation(
                  res: widget.reservation,
                  userId: user.id,
                  userName: user.name,
                  photoUrl: _imagePath!,
                  preferredCity: cityProvider.selectedCity,
                  notes: _descController.text.trim(),
                );

                if (mounted) {
                  setState(() => _isUploading = false);
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Photo evidence submitted and help marked as Completed!',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isUploading = false);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _imagePath = file.path);
    }
  }
}

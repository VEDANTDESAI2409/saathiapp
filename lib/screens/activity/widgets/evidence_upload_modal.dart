import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/reservation_model.dart';

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
            'Upload Fulfilment Evidence',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.deepForest,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Provide photo proof for "${widget.reservation.postTitle}".',
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
                border: Border.all(color: AppColors.trustTeal, width: 1),
              ),
              child: _imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Text('Photo Selected')),
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
                          'Tap to select photo',
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
              labelText: 'Notes / Description',
              hintText: 'e.g., Handed over 10 ration packets at night shelter.',
            ),
          ),
          const SizedBox(height: 24),

          AppButton(
            label: 'Submit Evidence',
            width: double.infinity,
            isLoading: _isUploading,
            onPressed: () async {
              setState(() => _isUploading = true);
              await Future.delayed(const Duration(seconds: 1));
              setState(() => _isUploading = false);

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Photo evidence uploaded successfully!'),
                  ),
                );
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

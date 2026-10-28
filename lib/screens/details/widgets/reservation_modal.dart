import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/post_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/post_provider.dart';

class ReservationModal extends StatefulWidget {
  final PostModel post;

  const ReservationModal({super.key, required this.post});

  @override
  State<ReservationModal> createState() => _ReservationModalState();
}

class _ReservationModalState extends State<ReservationModal> {
  int _reservedQty = 1;
  final TextEditingController _noteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    final user = authProvider.currentUser;
    final maxQty = widget.post.remainingQuantity;

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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            widget.post.isNeed
                ? 'Offer Assistance to Request'
                : 'Reserve Offered Assistance',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.deepForest,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.post.title} (${widget.post.remainingQuantity} remaining)',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Quantity Selector
          const Text(
            'Select Quantity / Items to Reserve',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.deepForest,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.trustTeal,
                onPressed: _reservedQty > 1
                    ? () => setState(() => _reservedQty--)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softMint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_reservedQty',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepForest,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.trustTeal,
                onPressed: _reservedQty < maxQty
                    ? () => setState(() => _reservedQty++)
                    : null,
              ),
              const Spacer(),
              Text(
                'Max: $maxQty',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Optional Note
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Message to Poster (Optional)',
              hintText: 'e.g., I can drop this off today at 5 PM',
            ),
          ),
          const SizedBox(height: 24),

          AppButton(
            label: 'Confirm Reservation',
            width: double.infinity,
            isLoading: _isSubmitting,
            onPressed: () async {
              if (user == null) return;
              setState(() => _isSubmitting = true);

              try {
                await postProvider.reserveHelp(
                  post: widget.post,
                  reservedById: user.id,
                  reservedByName: user.name,
                  reservedQuantity: _reservedQty,
                  note: _noteController.text.trim(),
                );
                setState(() => _isSubmitting = false);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Reservation confirmed! Check Activity tab to coordinate.',
                      ),
                    ),
                  );
                }
              } catch (e) {
                setState(() => _isSubmitting = false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reservation failed: ${e.toString()}'),
                    ),
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
}

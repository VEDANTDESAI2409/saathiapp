import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../providers/post_provider.dart';

class MonthlyLimitScreen extends StatefulWidget {
  const MonthlyLimitScreen({super.key});

  @override
  State<MonthlyLimitScreen> createState() => _MonthlyLimitScreenState();
}

class _MonthlyLimitScreenState extends State<MonthlyLimitScreen> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    final usage = postProvider.currentMonthlyUsage;

    final count = usage?.count ?? 0;
    final limit = usage?.limit ?? 15;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Monthly Help Limit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usage Progress Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Current Month Participation',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepForest,
                        ),
                      ),
                      Text(
                        '$count / $limit Instances',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.trustTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: count / limit,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      count >= limit
                          ? AppColors.emergencyRed
                          : AppColors.trustTeal,
                    ),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'To prevent commercial abuse and ensure fair distribution, SaathiApp sets a default limit of 15 help instances per month per account.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Request Limit Exception Form
            const Text(
              'Request Limit Exception',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.deepForest,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you are managing a genuine emergency or community distribution drive requiring additional capacity, request an exception for admin review.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Reason for Additional Capacity',
                hintText: 'Explain the situation, community drive details, or emergency requirement...',
              ),
            ),
            const SizedBox(height: 20),

            AppButton(
              label: 'Submit Exception Request',
              width: double.infinity,
              isLoading: _isSubmitting,
              onPressed: () async {
                if (_reasonController.text.trim().isEmpty) return;

                final messenger = ScaffoldMessenger.of(context);

                setState(() => _isSubmitting = true);
                await Future.delayed(const Duration(seconds: 1));

                if (mounted) {
                  setState(() => _isSubmitting = false);
                  _reasonController.clear();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Limit exception request submitted for management review.',
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

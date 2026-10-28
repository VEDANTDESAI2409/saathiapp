import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'verification_submission_screen.dart';

class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final isVerified = user?.isVerified ?? false;
    final status = user?.verificationStatus ?? 'unverified';

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Verification Status')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(
                    isVerified ? Icons.verified : Icons.pending_actions_rounded,
                    size: 64,
                    color: isVerified
                        ? AppColors.trustTeal
                        : AppColors.warmOrange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isVerified
                        ? 'Verified Member'
                        : 'Verification Status: ${status.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isVerified
                        ? 'Your identity has been verified by SaathiApp administration. You hold a trusted community badge.'
                        : 'Your submitted documents are undergoing administrative review. Verification badges display once approved.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (!isVerified && status != 'pending')
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Submit Verification Documents'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.trustTeal,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerificationSubmissionScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

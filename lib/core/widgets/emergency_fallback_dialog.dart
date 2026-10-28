import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../config/app_config.dart';
import '../localization/app_localizations.dart';

class EmergencyFallbackDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onSaveDraft;

  const EmergencyFallbackDialog({
    super.key,
    required this.onRetry,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final helpline = AppConfig.helplineNumber;

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.emergencyRed,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              loc.translate('emergencyFallbackTitle'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepForest,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('emergencyFallbackDesc'),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.softMint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.trustTeal.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_in_talk, color: AppColors.trustTeal),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Charity Management Helpline',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      helpline,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepForest,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSaveDraft();
            Navigator.pop(context);
          },
          child: Text(loc.translate('saveDraft')),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emergencyRed,
            foregroundColor: AppColors.white,
          ),
          icon: const Icon(Icons.phone),
          label: Text(loc.translate('callHelpline')),
          onPressed: () async {
            final Uri url = Uri.parse('tel:${helpline.replaceAll(' ', '')}');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/config/app_config.dart';
import '../../core/widgets/app_button.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final helpline = AppConfig.helplineNumber;
    final isConfigured = AppConfig.isHelplineConfigured();

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Management Helpline & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.softMint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.headset_mic_rounded,
                      color: AppColors.trustTeal,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SaathiApp Helpline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConfig.helplineHours,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (isConfigured) ...[
                    Text(
                      helpline,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.trustTeal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Call Helpline Now',
                      icon: Icons.phone,
                      width: double.infinity,
                      onPressed: () async {
                        final Uri url = Uri.parse(
                          'tel:${helpline.replaceAll(' ', '')}',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warmOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Helpline number not configured in current environment. Please configure AppConfig.helplineNumber.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.deepForest,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'How can we help?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.deepForest,
              ),
            ),
            const SizedBox(height: 12),

            _faqCard(
              'Unanswered Emergency Requests',
              'Escalate urgent blood or medical needs to our team.',
            ),
            _faqCard(
              'Dispute & Misuse Escalation',
              'Report unfulfilled reservations or inappropriate post content.',
            ),
            _faqCard(
              'Monthly Limit Exception',
              'Get assistance for high-capacity community distribution drives.',
            ),
            _faqCard(
              'Verification Support',
              'Check identity submission status or resubmit verification.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _faqCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.deepForest,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

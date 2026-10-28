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
            // Banner Card
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
                    'SaathiApp Management Support',
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
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.softMint,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.phone_disabled_outlined,
                            color: AppColors.textMuted,
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Helpline number not configured',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepForest,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Management helpline phone number must be configured in AppConfig.helplineNumber before release.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const AppButton(
                      label: 'Call Helpline (Unavailable)',
                      icon: Icons.phone,
                      width: double.infinity,
                      onPressed: null, // Disabled action
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
              'Escalate urgent blood or medical needs to our support team.',
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

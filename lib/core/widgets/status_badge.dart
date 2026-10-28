import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../localization/app_localizations.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    Color color = AppColors.statusOpen;
    String labelKey = 'statusOpen';

    switch (status) {
      case 'open':
        color = AppColors.statusOpen;
        labelKey = 'statusOpen';
        break;
      case 'assistance_offered':
        color = AppColors.statusOffered;
        labelKey = 'statusAssistanceOffered';
        break;
      case 'help_arranged':
        color = AppColors.statusArranged;
        labelKey = 'statusHelpArranged';
        break;
      case 'help_received':
      case 'completed':
        color = AppColors.statusCompleted;
        labelKey = 'statusHelpReceived';
        break;
      case 'closed':
        color = AppColors.statusClosed;
        labelKey = 'statusClosed';
        break;
      case 'expired':
        color = AppColors.statusExpired;
        labelKey = 'statusExpired';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Text(
        loc.translate(labelKey),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

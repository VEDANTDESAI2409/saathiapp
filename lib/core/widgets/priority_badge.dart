import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../localization/app_localizations.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    Color bg = AppColors.softMint;
    Color fg = AppColors.deepForest;
    String label = loc.translate('normalPriority');
    IconData icon = Icons.info_outline;

    if (priority == 'emergency') {
      bg = AppColors.emergencyRed;
      fg = AppColors.white;
      label = loc.translate('emergency');
      icon = Icons.warning_amber_rounded;
    } else if (priority == 'high') {
      bg = AppColors.warmOrange;
      fg = AppColors.deepForest;
      label = loc.translate('highPriority');
      icon = Icons.priority_high;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

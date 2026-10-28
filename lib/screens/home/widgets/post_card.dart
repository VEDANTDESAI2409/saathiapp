import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/priority_badge.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/post_model.dart';
import '../../details/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isNeed = post.isNeed;
    final badgeBg = isNeed ? AppColors.trustTeal : AppColors.warmOrange;
    final badgeLabel = isNeed ? 'NEED' : 'OFFER';

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Need/Offer tag + Priority + Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeLabel,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PriorityBadge(priority: post.priority),
              const Spacer(),
              StatusBadge(status: post.status),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.deepForest,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Description snippet
          Text(
            post.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Quantity Progress Bar
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 14,
                color: AppColors.trustTeal,
              ),
              const SizedBox(width: 6),
              Text(
                'Remaining: ${post.remainingQuantity} of ${post.totalQuantity}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepForest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: post.totalQuantity > 0
                  ? (post.remainingQuantity / post.totalQuantity)
                  : 0.0,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                isNeed ? AppColors.trustTeal : AppColors.warmOrange,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),

          // Footer Row: Area & User Avatar
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${post.areaName}, ${post.city}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.softMint,
                backgroundImage: post.userAvatar.isNotEmpty
                    ? NetworkImage(post.userAvatar)
                    : null,
                child: post.userAvatar.isEmpty
                    ? Text(
                        post.userName.isNotEmpty ? post.userName[0] : 'U',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 6),
              Text(
                post.userName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (post.userIsVerified) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified,
                  size: 14,
                  color: AppColors.trustTeal,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

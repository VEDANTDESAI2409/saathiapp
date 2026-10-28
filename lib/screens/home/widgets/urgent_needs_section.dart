import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/post_model.dart';
import '../../details/post_detail_screen.dart';

class UrgentNeedsSection extends StatelessWidget {
  final List<PostModel> urgentPosts;

  const UrgentNeedsSection({super.key, required this.urgentPosts});

  @override
  Widget build(BuildContext context) {
    if (urgentPosts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.emergencyRed,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Urgent & Emergency Needs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepForest,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.emergencyRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${urgentPosts.length} Urgent',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emergencyRed,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: urgentPosts.length,
            itemBuilder: (context, i) {
              final post = urgentPosts[i];
              return Container(
                width: 260,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Card(
                  elevation: 2,
                  color: post.isEmergency
                      ? const Color(0xFFFFF0F0)
                      : AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: post.isEmergency
                          ? AppColors.emergencyRed
                          : AppColors.warmOrange,
                      width: 1.2,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: post.isEmergency
                                      ? AppColors.emergencyRed
                                      : AppColors.warmOrange,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  post.isEmergency
                                      ? 'EMERGENCY'
                                      : 'HIGH PRIORITY',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                post.areaName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepForest,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Needed: ${post.remainingQuantity}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.trustTeal,
                                ),
                              ),
                              const Text(
                                'Respond Now →',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.trustTeal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

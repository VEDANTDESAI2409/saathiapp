import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/priority_badge.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/models/post_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/admin_provider.dart';
import '../chat/chat_detail_screen.dart';
import 'widgets/reservation_modal.dart';
import '../../data/models/report_model.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final adminProvider = Provider.of<AdminProvider>(context);

    final currentUser = authProvider.currentUser;
    final preferredCity = cityProvider.selectedCity;
    final isOwner = currentUser?.id == post.userId;
    final isNeed = post.isNeed;
    final unitLabel = post.quantityUnit.isNotEmpty
        ? post.quantityUnit
        : 'items';

    // Requirement 1: City matching rule for fulfillment eligibility
    final isSameCity =
        preferredCity.trim().toLowerCase() == post.city.trim().toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: Text(isNeed ? 'Request Details' : 'Offer Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'report') {
                _showReportDialog(
                  context,
                  adminProvider,
                  currentUser?.id ?? '',
                );
              } else if (val == 'block') {
                if (currentUser != null) {
                  adminProvider.blockUser(currentUser.id, post.userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User ${post.userName} blocked.')),
                  );
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'report', child: Text('Report Post')),
              PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Out-of-city Restriction Warning Banner (Requirement 1)
            if (!isSameCity && !isOwner)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warmOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warmOrange),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      color: AppColors.warmOrange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Out of city: Your preferred city is $preferredCity. You can only fulfill help requests in $preferredCity. Change your preferred city in Profile to participate in ${post.city}.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.deepForest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Top Badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isNeed ? AppColors.trustTeal : AppColors.warmOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isNeed ? 'NEED REQUEST' : 'ASSISTANCE OFFER',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
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
            const SizedBox(height: 16),

            // Title
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.deepForest,
              ),
            ),
            const SizedBox(height: 8),

            // Category & Location
            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: AppColors.trustTeal,
                ),
                const SizedBox(width: 6),
                Text(
                  post.categoryName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepForest,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.areaName}, ${post.city}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Requirement 10: Display uploaded photos for Offers and Needs
            if (post.mediaUrls.isNotEmpty) ...[
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.mediaUrls.length,
                  itemBuilder: (context, i) {
                    final url = post.mediaUrls[i];
                    return GestureDetector(
                      onTap: () {
                        // Full Image Lightbox Viewer
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                url,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      padding: const EdgeInsets.all(32),
                                      color: AppColors.white,
                                      child: const Text(
                                        'Image preview unavailable',
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 280,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Quantity Tracker Card
            Container(
              padding: const EdgeInsets.all(16),
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
                        'Fulfilment Progress',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepForest,
                        ),
                      ),
                      Text(
                        '${post.remainingQuantity} of ${post.totalQuantity} $unitLabel',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.trustTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: post.totalQuantity > 0
                          ? (post.remainingQuantity / post.totalQuantity)
                          : 0,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isNeed ? AppColors.trustTeal : AppColors.warmOrange,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.deepForest,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.deepForest,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Instructions / Contact Notes
            if (post.contactInstructions.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.softMint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.trustTeal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fulfilment Instructions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepForest,
                            ),
                          ),
                          Text(
                            post.contactInstructions,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // User Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.trustTeal,
                    backgroundImage: post.userAvatar.isNotEmpty
                        ? NetworkImage(post.userAvatar)
                        : null,
                    child: post.userAvatar.isEmpty
                        ? Text(
                            post.userName.isNotEmpty ? post.userName[0] : 'U',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.userName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepForest,
                              ),
                            ),
                            if (post.userIsVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                size: 16,
                                color: AppColors.trustTeal,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          'Posted in ${post.city}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softMint,
                      foregroundColor: AppColors.deepForest,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text('Chat'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(
                            conversationId: 'conv_${post.id}',
                            partnerName: post.userName,
                            partnerId: post.userId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            // Requirement 1 & 11 logic:
            if (!isOwner && post.status == 'open' && post.remainingQuantity > 0)
              AppButton(
                label: isNeed ? 'Offer Help / Reserve' : 'Request Assistance',
                width: double.infinity,
                variant: isSameCity
                    ? AppButtonVariant.primary
                    : AppButtonVariant.secondary,
                onPressed: isSameCity
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => ReservationModal(post: post),
                        );
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Fulfillment restricted: You can only fulfill help requests in your preferred city ($preferredCity).',
                            ),
                          ),
                        );
                      },
              )
            else if (isOwner && post.status == 'open')
              AppButton(
                label: 'Close Post Early',
                width: double.infinity,
                variant: AppButtonVariant.outlined,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(context);
                  await postProvider.closePostEarly(post.id, preferredCity);
                  if (context.mounted) {
                    nav.pop();
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Post closed early.')),
                    );
                  }
                },
              )
            else if (isOwner &&
                (post.status == 'closed' || post.isClosedEarly) &&
                post.status != 'completed')
              // Requirement 11: Reopen behavior for closed incomplete posts
              AppButton(
                label: 'Reopen Post',
                width: double.infinity,
                variant: AppButtonVariant.primary,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(context);
                  await postProvider.reopenPost(post.id, preferredCity);
                  if (context.mounted) {
                    nav.pop();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Post reopened successfully!'),
                      ),
                    );
                  }
                },
              )
            else if (post.status == 'completed')
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.softMint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Assistance Completed. Completed posts cannot be reopened.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.trustTeal,
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(
    BuildContext context,
    AdminProvider adminProvider,
    String reporterId,
  ) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Report Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Why are you reporting this post?'),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Inappropriate content or spam',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                adminProvider.submitReport(
                  ReportModel(
                    id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
                    reporterId: reporterId,
                    targetType: 'post',
                    targetId: post.id,
                    targetTitle: post.title,
                    reason: reasonController.text.trim(),
                    timestamp: DateTime.now()
                        .toIso8601String()
                        .split('.')
                        .first,
                  ),
                );
                Navigator.pop(ctx);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Report submitted for review.')),
                );
              },
              child: const Text('Submit Report'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../data/models/reservation_model.dart';
import '../chat/chat_detail_screen.dart';
import 'widgets/evidence_upload_modal.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    final user = authProvider.currentUser;
    final reservations = postProvider.userReservations;

    // Requirement 14: Helps Done contains ONLY completed activities where user provided help
    final helpsDoneCompleted = reservations
        .where((r) => r.reservedById == user?.id && r.status == 'completed')
        .toList();

    // Helps Taken contains completed requests where user was recipient
    final helpsTakenCompleted = reservations
        .where((r) => r.postOwnerId == user?.id && r.status == 'completed')
        .toList();

    // Active Reservations contains in-progress activities
    final activeReservations = reservations
        .where((r) => r.status != 'completed' && r.status != 'cancelled')
        .toList();

    return Column(
      children: [
        Container(
          color: AppColors.warmCream,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.trustTeal,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.trustTeal,
            tabs: const [
              Tab(text: 'Helps Done'),
              Tab(text: 'Helps Taken'),
              Tab(text: 'Active'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPhotoActivityList(
                context,
                helpsDoneCompleted,
                isCompletedView: true,
              ),
              _buildPhotoActivityList(
                context,
                helpsTakenCompleted,
                isCompletedView: true,
              ),
              _buildPhotoActivityList(
                context,
                activeReservations,
                isCompletedView: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Requirement 13: Instagram-style photo-centric card layout for Activity History
  Widget _buildPhotoActivityList(
    BuildContext context,
    List<ReservationModel> reservations, {
    required bool isCompletedView,
  }) {
    if (reservations.isEmpty) {
      return const EmptyStateWidget(
        title: 'No activity records found',
        description: 'Your completed photo-documented help interactions will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, i) {
        final res = reservations[i];

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Header Thumbnail / Canvas (Instagram style)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.softMint,
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1593113598332-cd288d649433?w=500',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.deepForest.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.trustTeal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              res.categoryName,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          StatusBadge(status: res.status),
                        ],
                      ),
                      Text(
                        res.postTitle,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Details Row
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: AppColors.trustTeal,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Quantity: ${res.reservedQuantity} items',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    res.createdAt,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              if (res.note.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Note: "${res.note}"',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // Actions Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.chat_outlined, size: 16),
                      label: const Text('Chat'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetailScreen(
                              conversationId: 'conv_${res.postId}',
                              partnerName: res.postOwnerName,
                              partnerId: res.postOwnerId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                      label: const Text('Evidence'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => EvidenceUploadModal(reservation: res),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Requirement 12: Mandatory evidence upload modal triggers when tapping "Complete Assistance"
              if (!isCompletedView) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.trustTeal,
                      foregroundColor: AppColors.white,
                    ),
                    icon: const Icon(Icons.verified_outlined, size: 18),
                    label: const Text('Complete Assistance (Photo Required)'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => EvidenceUploadModal(reservation: res),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/city_provider.dart';
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

    final helpsDone = reservations
        .where((r) => r.reservedById == user?.id)
        .toList();
    final helpsTaken = reservations
        .where((r) => r.postOwnerId == user?.id)
        .toList();
    final active = reservations
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
              _buildList(context, helpsDone),
              _buildList(context, helpsTaken),
              _buildList(context, active),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, List reservations) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (reservations.isEmpty) {
      return const EmptyStateWidget(
        title: 'No activity records found',
        description:
            'Your completed or active help interactions will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, i) {
        final res = reservations[i];
        final isCompleted = res.status == 'completed';

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    res.categoryName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.trustTeal,
                    ),
                  ),
                  const Spacer(),
                  StatusBadge(status: res.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                res.postTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepForest,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Reserved Qty: ${res.reservedQuantity} item(s)',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

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
              if (!isCompleted) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.trustTeal,
                      foregroundColor: AppColors.white,
                    ),
                    onPressed: () async {
                      final userId = authProvider.currentUser?.id ?? '';
                      await postProvider.completeReservation(
                        res,
                        userId,
                        cityProvider.selectedCity,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Activity marked as completed! Score updated.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Mark as Completed'),
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

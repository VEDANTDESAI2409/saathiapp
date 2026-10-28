import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchAdminData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final metrics = adminProvider.metrics;
    final verifications = adminProvider.verificationQueue;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Admin Operations Dashboard')),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Operational Metrics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _metricTile(
                        'Open Needs',
                        '${metrics['openNeeds'] ?? 0}',
                        AppColors.trustTeal,
                      ),
                      _metricTile(
                        'Open Offers',
                        '${metrics['openOffers'] ?? 0}',
                        AppColors.warmOrange,
                      ),
                      _metricTile(
                        'Open Emergencies',
                        '${metrics['emergencies'] ?? 0}',
                        AppColors.emergencyRed,
                      ),
                      _metricTile(
                        'Pending Verifications',
                        '${metrics['pendingVerifications'] ?? 0}',
                        AppColors.trustTeal,
                      ),
                      _metricTile(
                        'Active Reports',
                        '${metrics['activeReports'] ?? 0}',
                        AppColors.emergencyRed,
                      ),
                      _metricTile(
                        'Completed Help',
                        '${metrics['completedHelp'] ?? 0}',
                        AppColors.statusCompleted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Pending Identity Verifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (verifications.isEmpty)
                    const Text(
                      'No pending verifications in queue.',
                      style: TextStyle(color: AppColors.textMuted),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: verifications.length,
                      itemBuilder: (context, i) {
                        final v = verifications[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    v.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.softMint,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      v.status.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.trustTeal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Doc: ${v.documentType} (${v.documentNumber})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              if (v.status == 'pending')
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.emergencyRed,
                                        ),
                                        onPressed: () {
                                          adminProvider.reviewVerification(
                                            v.id,
                                            'rejected',
                                            'Document details clear match failed.',
                                          );
                                        },
                                        child: const Text('Reject'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.trustTeal,
                                          foregroundColor: AppColors.white,
                                        ),
                                        onPressed: () {
                                          adminProvider.reviewVerification(
                                            v.id,
                                            'approved',
                                            'Verified by admin.',
                                          );
                                        },
                                        child: const Text('Approve'),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

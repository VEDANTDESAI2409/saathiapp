import 'package:flutter/material.dart';

import '../data/models/verification_model.dart';
import '../data/models/report_model.dart';
import '../data/repositories/admin_repository.dart';

class AdminProvider extends ChangeNotifier {
  final AdminRepository _repository = AdminRepository();

  Map<String, int> _metrics = {};
  List<VerificationSubmissionModel> _verificationQueue = [];
  List<ReportModel> _reports = [];
  bool _isLoading = false;

  Map<String, int> get metrics => _metrics;
  List<VerificationSubmissionModel> get verificationQueue => _verificationQueue;
  List<ReportModel> get reports => _reports;
  bool get isLoading => _isLoading;

  Future<void> fetchAdminData() async {
    _isLoading = true;
    notifyListeners();

    _metrics = await _repository.getOperationalMetrics();
    _verificationQueue = await _repository.getVerificationQueue();
    _reports = await _repository.getReports();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> reviewVerification(
    String id,
    String status,
    String notes,
  ) async {
    await _repository.reviewVerification(id, status, notes);
    await fetchAdminData();
  }

  Future<void> submitReport(ReportModel report) async {
    await _repository.submitReport(report);
    await fetchAdminData();
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    await _repository.blockUser(userId, blockedUserId);
    notifyListeners();
  }
}

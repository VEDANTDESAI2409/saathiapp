import 'package:flutter/material.dart';

import '../data/models/verification_model.dart';
import '../data/repositories/admin_repository.dart';

class VerificationProvider extends ChangeNotifier {
  final AdminRepository _repository = AdminRepository();

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<void> submitVerification(
    VerificationSubmissionModel submission,
  ) async {
    _isSubmitting = true;
    notifyListeners();

    await _repository.submitVerification(submission);

    _isSubmitting = false;
    notifyListeners();
  }
}

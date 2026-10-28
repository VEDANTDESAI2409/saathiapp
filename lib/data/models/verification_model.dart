class VerificationSubmissionModel {
  final String id;
  final String userId;
  final String userName;
  final String documentType; // 'Aadhaar Card', 'Voter ID', 'Driving License', 'Government ID'
  final String documentNumber;
  final String documentFrontUrl;
  final String documentBackUrl;
  final String
  status; // 'pending', 'approved', 'rejected', 'resubmission_required'
  final String adminNotes;
  final String submittedAt;

  VerificationSubmissionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.documentType,
    required this.documentNumber,
    required this.documentFrontUrl,
    this.documentBackUrl = '',
    this.status = 'pending',
    this.adminNotes = '',
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'documentType': documentType,
      'documentNumber': documentNumber,
      'documentFrontUrl': documentFrontUrl,
      'documentBackUrl': documentBackUrl,
      'status': status,
      'adminNotes': adminNotes,
      'submittedAt': submittedAt,
    };
  }

  factory VerificationSubmissionModel.fromMap(Map<String, dynamic> map) {
    return VerificationSubmissionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      documentType: map['documentType'] ?? 'Government ID',
      documentNumber: map['documentNumber'] ?? '',
      documentFrontUrl: map['documentFrontUrl'] ?? '',
      documentBackUrl: map['documentBackUrl'] ?? '',
      status: map['status'] ?? 'pending',
      adminNotes: map['adminNotes'] ?? '',
      submittedAt: map['submittedAt'] ?? '',
    );
  }
}

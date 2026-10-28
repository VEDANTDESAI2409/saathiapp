class ReportModel {
  final String id;
  final String reporterId;
  final String targetType; // 'post', 'user', 'content'
  final String targetId;
  final String targetTitle;
  final String reason;
  final String details;
  final String timestamp;
  final String status; // 'pending', 'reviewed', 'action_taken', 'dismissed'

  ReportModel({
    required this.id,
    required this.reporterId,
    required this.targetType,
    required this.targetId,
    required this.targetTitle,
    required this.reason,
    this.details = '',
    required this.timestamp,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporterId': reporterId,
      'targetType': targetType,
      'targetId': targetId,
      'targetTitle': targetTitle,
      'reason': reason,
      'details': details,
      'timestamp': timestamp,
      'status': status,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      reporterId: map['reporterId'] ?? '',
      targetType: map['targetType'] ?? 'post',
      targetId: map['targetId'] ?? '',
      targetTitle: map['targetTitle'] ?? '',
      reason: map['reason'] ?? 'Inappropriate Content',
      details: map['details'] ?? '',
      timestamp: map['timestamp'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}

class MonthlyUsageModel {
  final String userId;
  final String yearMonth; // e.g. "2026-10"
  final int count;
  final int limit;
  final bool exceptionRequested;
  final String exceptionReason;
  final String exceptionStatus; // 'none', 'pending', 'approved', 'rejected'

  MonthlyUsageModel({
    required this.userId,
    required this.yearMonth,
    this.count = 0,
    this.limit = 15,
    this.exceptionRequested = false,
    this.exceptionReason = '',
    this.exceptionStatus = 'none',
  });

  bool get isLimitReached => count >= limit && exceptionStatus != 'approved';

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'yearMonth': yearMonth,
      'count': count,
      'limit': limit,
      'exceptionRequested': exceptionRequested ? 1 : 0,
      'exceptionReason': exceptionReason,
      'exceptionStatus': exceptionStatus,
    };
  }

  factory MonthlyUsageModel.fromMap(Map<String, dynamic> map) {
    return MonthlyUsageModel(
      userId: map['userId'] ?? '',
      yearMonth: map['yearMonth'] ?? '',
      count: map['count'] ?? 0,
      limit: map['limit'] ?? 15,
      exceptionRequested:
          map['exceptionRequested'] == 1 || map['exceptionRequested'] == true,
      exceptionReason: map['exceptionReason'] ?? '',
      exceptionStatus: map['exceptionStatus'] ?? 'none',
    );
  }
}

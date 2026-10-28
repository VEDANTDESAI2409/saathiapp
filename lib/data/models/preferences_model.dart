class UserPreferencesModel {
  final String userId;
  final bool emergencyAlerts;
  final bool categoryUpdates;
  final bool reservationAlerts;
  final bool chatMessages;
  final bool communityBanners;

  UserPreferencesModel({
    required this.userId,
    this.emergencyAlerts = true,
    this.categoryUpdates = true,
    this.reservationAlerts = true,
    this.chatMessages = true,
    this.communityBanners = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'emergencyAlerts': emergencyAlerts ? 1 : 0,
      'categoryUpdates': categoryUpdates ? 1 : 0,
      'reservationAlerts': reservationAlerts ? 1 : 0,
      'chatMessages': chatMessages ? 1 : 0,
      'communityBanners': communityBanners ? 1 : 0,
    };
  }

  factory UserPreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserPreferencesModel(
      userId: map['userId'] ?? '',
      emergencyAlerts:
          map['emergencyAlerts'] == 1 || map['emergencyAlerts'] == true,
      categoryUpdates:
          map['categoryUpdates'] == 1 || map['categoryUpdates'] == true,
      reservationAlerts:
          map['reservationAlerts'] == 1 || map['reservationAlerts'] == true,
      chatMessages: map['chatMessages'] == 1 || map['chatMessages'] == true,
      communityBanners:
          map['communityBanners'] == 1 || map['communityBanners'] == true,
    );
  }
}

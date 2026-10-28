class BannerModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String
  actionType; // 'category', 'emergency', 'helpline', 'verification'
  final String actionPayload;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.actionType = 'category',
    this.actionPayload = '',
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'actionType': actionType,
      'actionPayload': actionPayload,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      actionType: map['actionType'] ?? 'category',
      actionPayload: map['actionPayload'] ?? '',
      isActive: map['isActive'] == 1 || map['isActive'] == true,
    );
  }
}

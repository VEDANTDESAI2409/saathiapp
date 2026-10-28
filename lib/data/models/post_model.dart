import 'dart:convert';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final bool userIsVerified;
  final String type; // 'need' or 'offer'
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final String priority; // 'emergency', 'high', 'normal'
  final int totalQuantity;
  final int remainingQuantity;
  final String quantityUnit; // e.g., 'meals', 'pairs', 'books', 'units'
  final String city;
  final String areaName;
  final double? latitude;
  final double? longitude;
  final String durationText;
  final String expiresAt;
  final String status; // 'open', 'assistance_offered', 'help_arranged', 'help_received', 'completed', 'closed', 'expired'
  final List<String> mediaUrls;
  final String contactInstructions;
  final bool isClosedEarly;
  final String createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    this.userIsVerified = false,
    required this.type,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    this.priority = 'normal',
    required this.totalQuantity,
    required this.remainingQuantity,
    this.quantityUnit = 'items',
    required this.city,
    required this.areaName,
    this.latitude,
    this.longitude,
    this.durationText = 'Until fulfilled',
    this.expiresAt = '',
    this.status = 'open',
    this.mediaUrls = const [],
    this.contactInstructions = '',
    this.isClosedEarly = false,
    required this.createdAt,
  });

  bool get isEmergency => priority == 'emergency';
  bool get isNeed => type == 'need';
  bool get isOffer => type == 'offer';
  bool get isCompleted => status == 'completed';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'userIsVerified': userIsVerified ? 1 : 0,
      'type': type,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'priority': priority,
      'totalQuantity': totalQuantity,
      'remainingQuantity': remainingQuantity,
      'quantityUnit': quantityUnit,
      'city': city,
      'areaName': areaName,
      'latitude': latitude,
      'longitude': longitude,
      'durationText': durationText,
      'expiresAt': expiresAt,
      'status': status,
      'mediaUrls': jsonEncode(mediaUrls),
      'contactInstructions': contactInstructions,
      'isClosedEarly': isClosedEarly ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    List<String> media = [];
    if (map['mediaUrls'] != null && map['mediaUrls'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(map['mediaUrls']);
        if (decoded is List) {
          media = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        if (map['mediaUrls'] is String &&
            (map['mediaUrls'] as String).isNotEmpty) {
          media = [map['mediaUrls'] as String];
        }
      }
    }

    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userAvatar: map['userAvatar'] ?? '',
      userIsVerified:
          map['userIsVerified'] == 1 || map['userIsVerified'] == true,
      type: map['type'] ?? 'need',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? 'General',
      priority: map['priority'] ?? 'normal',
      totalQuantity: map['totalQuantity'] ?? 1,
      remainingQuantity: map['remainingQuantity'] ?? 1,
      quantityUnit: map['quantityUnit'] ?? 'items',
      city: map['city'] ?? 'Ahmedabad',
      areaName: map['areaName'] ?? '',
      latitude: map['latitude'] != null
          ? (map['latitude'] as num).toDouble()
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      durationText: map['durationText'] ?? 'Until fulfilled',
      expiresAt: map['expiresAt'] ?? '',
      status: map['status'] ?? 'open',
      mediaUrls: media,
      contactInstructions: map['contactInstructions'] ?? '',
      isClosedEarly: map['isClosedEarly'] == 1 || map['isClosedEarly'] == true,
      createdAt: map['createdAt'] ?? '',
    );
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    bool? userIsVerified,
    String? type,
    String? title,
    String? description,
    String? categoryId,
    String? categoryName,
    String? priority,
    int? totalQuantity,
    int? remainingQuantity,
    String? quantityUnit,
    String? city,
    String? areaName,
    double? latitude,
    double? longitude,
    String? durationText,
    String? expiresAt,
    String? status,
    List<String>? mediaUrls,
    String? contactInstructions,
    bool? isClosedEarly,
    String? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      userIsVerified: userIsVerified ?? this.userIsVerified,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      priority: priority ?? this.priority,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      city: city ?? this.city,
      areaName: areaName ?? this.areaName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      durationText: durationText ?? this.durationText,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      contactInstructions: contactInstructions ?? this.contactInstructions,
      isClosedEarly: isClosedEarly ?? this.isClosedEarly,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

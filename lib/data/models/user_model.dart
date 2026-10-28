class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String registeredCity;
  final String avatarUrl;
  final bool isVerified;
  final String
  verificationStatus; // 'unverified', 'pending', 'approved', 'rejected'
  final int contributionScore;
  final int helpsDoneCount;
  final int helpsTakenCount;
  final String role; // 'user', 'admin'
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.registeredCity,
    this.avatarUrl = '',
    this.isVerified = false,
    this.verificationStatus = 'unverified',
    this.contributionScore = 0,
    this.helpsDoneCount = 0,
    this.helpsTakenCount = 0,
    this.role = 'user',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'registeredCity': registeredCity,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified ? 1 : 0,
      'verificationStatus': verificationStatus,
      'contributionScore': contributionScore,
      'helpsDoneCount': helpsDoneCount,
      'helpsTakenCount': helpsTakenCount,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      registeredCity: map['registeredCity'] ?? 'Ahmedabad',
      avatarUrl: map['avatarUrl'] ?? '',
      isVerified: map['isVerified'] == 1 || map['isVerified'] == true,
      verificationStatus: map['verificationStatus'] ?? 'unverified',
      contributionScore: map['contributionScore'] ?? 0,
      helpsDoneCount: map['helpsDoneCount'] ?? 0,
      helpsTakenCount: map['helpsTakenCount'] ?? 0,
      role: map['role'] ?? 'user',
      createdAt: map['createdAt'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? registeredCity,
    String? avatarUrl,
    bool? isVerified,
    String? verificationStatus,
    int? contributionScore,
    int? helpsDoneCount,
    int? helpsTakenCount,
    String? role,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      registeredCity: registeredCity ?? this.registeredCity,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      contributionScore: contributionScore ?? this.contributionScore,
      helpsDoneCount: helpsDoneCount ?? this.helpsDoneCount,
      helpsTakenCount: helpsTakenCount ?? this.helpsTakenCount,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final String description;
  final int activeNeedsCount;
  final int activeOffersCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.description,
    this.activeNeedsCount = 0,
    this.activeOffersCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'description': description,
      'activeNeedsCount': activeNeedsCount,
      'activeOffersCount': activeOffersCount,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      iconName: map['iconName'] ?? 'handshake',
      description: map['description'] ?? '',
      activeNeedsCount: map['activeNeedsCount'] ?? 0,
      activeOffersCount: map['activeOffersCount'] ?? 0,
    );
  }
}

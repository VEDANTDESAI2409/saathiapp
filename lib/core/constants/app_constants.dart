class AppConstants {
  // Supported Cities
  static const List<String> supportedCities = [
    'Ahmedabad',
    'Surat',
    'Vadodara',
    'Rajkot',
    'Gandhinagar',
    'Bhavnagar',
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Pune',
    'Jaipur',
  ];

  // Predefined Categories with Category Images and Units
  static const List<Map<String, String>> predefinedCategories = [
    {
      'id': 'cat_food',
      'name': 'Food & Groceries',
      'icon': 'restaurant',
      'desc': 'Cooked meals, raw ration, food packets',
      'imageUrl':
          'https://images.unsplash.com/photo-1593113598332-cd288d649433?w=500',
      'defaultUnit': 'meals',
    },
    {
      'id': 'cat_clothing',
      'name': 'Clothing & Wear',
      'icon': 'checkroom',
      'desc': 'Clean clothes, winter wear, blankets',
      'imageUrl':
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=500',
      'defaultUnit': 'pairs',
    },
    {
      'id': 'cat_education',
      'name': 'Education & Supplies',
      'icon': 'school',
      'desc': 'School fees support, stationery, uniform',
      'imageUrl':
          'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=500',
      'defaultUnit': 'kits',
    },
    {
      'id': 'cat_books',
      'name': 'Books & Learning',
      'icon': 'menu_book',
      'desc': 'Textbooks, competitive exam books, notebook packets',
      'imageUrl':
          'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=500',
      'defaultUnit': 'books',
    },
    {
      'id': 'cat_healthcare',
      'name': 'Healthcare & Medicines',
      'icon': 'medical_services',
      'desc': 'Prescription medicines, medical equipment, medical aid',
      'imageUrl':
          'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=500',
      'defaultUnit': 'units',
    },
    {
      'id': 'cat_household',
      'name': 'Household Essentials',
      'icon': 'home',
      'desc': 'Utensils, bedding, furniture, home repairs',
      'imageUrl':
          'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=500',
      'defaultUnit': 'units',
    },
    {
      'id': 'cat_other',
      'name': 'Other Assistance',
      'icon': 'handshake',
      'desc': 'Other genuine community mutual help needs',
      'imageUrl':
          'https://images.unsplash.com/photo-1532629345422-7515f3d16bb0?w=500',
      'defaultUnit': 'items',
    },
  ];

  // Map category ID to available units
  static const Map<String, List<String>> categoryUnits = {
    'cat_food': ['meals', 'packets', 'ration kits', 'kg'],
    'cat_clothing': ['pairs', 'items', 'sets'],
    'cat_education': ['kits', 'uniforms', 'sets'],
    'cat_books': ['books', 'sets', 'notebooks'],
    'cat_healthcare': ['units', 'doses', 'kits', 'strips'],
    'cat_household': ['units', 'items', 'sets'],
    'cat_other': ['items', 'units', 'hours'],
  };

  static String getDefaultUnitForCategory(String categoryId) {
    for (var cat in predefinedCategories) {
      if (cat['id'] == categoryId) {
        return cat['defaultUnit'] ?? 'items';
      }
    }
    return 'items';
  }

  // Priorities
  static const String priorityEmergency = 'emergency';
  static const String priorityHigh = 'high';
  static const String priorityNormal = 'normal';

  // Types
  static const String typeNeed = 'need';
  static const String typeOffer = 'offer';

  // Statuses
  static const String statusOpen = 'open';
  static const String statusAssistanceOffered = 'assistance_offered';
  static const String statusHelpArranged = 'help_arranged';
  static const String statusHelpReceived = 'help_received';
  static const String statusCompleted = 'completed';
  static const String statusClosed = 'closed';
  static const String statusExpired = 'expired';
}

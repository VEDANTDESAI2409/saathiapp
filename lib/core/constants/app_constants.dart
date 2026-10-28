class AppConstants {
  // Cities
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

  // Predefined Categories
  static const List<Map<String, String>> predefinedCategories = [
    {
      'id': 'cat_food',
      'name': 'Food & Groceries',
      'icon': 'restaurant',
      'desc': 'Cooked meals, raw ration, food packets',
    },
    {
      'id': 'cat_clothing',
      'name': 'Clothing & Wear',
      'icon': 'checkroom',
      'desc': 'Clean clothes, winter wear, blankets',
    },
    {
      'id': 'cat_education',
      'name': 'Education & Supplies',
      'icon': 'school',
      'desc': 'School fees support, stationery, uniform',
    },
    {
      'id': 'cat_books',
      'name': 'Books & Learning',
      'icon': 'menu_book',
      'desc': 'Textbooks, competitive exam books, notebook packets',
    },
    {
      'id': 'cat_healthcare',
      'name': 'Healthcare & Medicines',
      'icon': 'medical_services',
      'desc': 'Prescription medicines, medical equipment, medical aid',
    },
    {
      'id': 'cat_household',
      'name': 'Household Essentials',
      'icon': 'home',
      'desc': 'Utensils, bedding, furniture, home repairs',
    },
    {
      'id': 'cat_other',
      'name': 'Other Assistance',
      'icon': 'handshake',
      'desc': 'Other genuine community mutual help needs',
    },
  ];

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
  static const String statusClosed = 'closed';
  static const String statusExpired = 'expired';
}

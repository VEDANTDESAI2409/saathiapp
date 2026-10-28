import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/category_model.dart';

class ServiceCategoryStrip extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const ServiceCategoryStrip({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            final isSelected = selectedCategory == 'all';
            return _categoryChip(
              name: 'All',
              icon: Icons.grid_view_rounded,
              isSelected: isSelected,
              onTap: () => onSelectCategory('all'),
            );
          }
          final cat = categories[i - 1];
          final isSelected = selectedCategory == cat.id;
          return _categoryChip(
            name: cat.name,
            icon: _getCategoryIcon(cat.iconName),
            isSelected: isSelected,
            onTap: () => onSelectCategory(cat.id),
          );
        },
      ),
    );
  }

  Widget _categoryChip({
    required String name,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.trustTeal : AppColors.softMint,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.trustTeal : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.deepForest,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.trustTeal : AppColors.deepForest,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'restaurant':
        return Icons.restaurant;
      case 'checkroom':
        return Icons.checkroom;
      case 'school':
        return Icons.school;
      case 'menu_book':
        return Icons.menu_book;
      case 'medical_services':
        return Icons.medical_services;
      case 'home':
        return Icons.home;
      default:
        return Icons.handshake;
    }
  }
}

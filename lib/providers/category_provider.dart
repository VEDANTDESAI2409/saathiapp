import 'package:flutter/material.dart';

import '../data/models/category_model.dart';
import '../data/models/banner_model.dart';
import '../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();

  List<CategoryModel> _categories = [];
  List<BannerModel> _banners = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;

  CategoryProvider() {
    loadCategoriesAndBanners();
  }

  Future<void> loadCategoriesAndBanners() async {
    _isLoading = true;
    notifyListeners();

    _categories = await _categoryRepository.getCategories();
    _banners = await _categoryRepository.getActiveBanners();

    _isLoading = false;
    notifyListeners();
  }
}

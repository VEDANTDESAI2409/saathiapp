import '../database/db_helper.dart';
import '../models/category_model.dart';
import '../models/banner_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    final db = await DBHelper.database;
    final maps = await db.query('categories');
    return maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  Future<List<BannerModel>> getActiveBanners() async {
    final db = await DBHelper.database;
    final maps = await db.query('banners', where: 'isActive = 1');
    return maps.map((m) => BannerModel.fromMap(m)).toList();
  }
}

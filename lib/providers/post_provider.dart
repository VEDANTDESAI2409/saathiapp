import 'package:flutter/material.dart';

import '../data/models/post_model.dart';
import '../data/models/reservation_model.dart';
import '../data/models/monthly_usage_model.dart';
import '../data/repositories/post_repository.dart';
import '../data/repositories/reservation_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  final ReservationRepository _reservationRepository = ReservationRepository();

  List<PostModel> _posts = [];
  List<ReservationModel> _userReservations = [];
  MonthlyUsageModel? _currentMonthlyUsage;
  bool _isLoading = false;
  String _selectedCategoryFilter = 'all';
  String _selectedTypeFilter = 'all';
  String _selectedPriorityFilter = 'all';
  String _searchQuery = '';

  List<PostModel> get posts => _posts;
  List<ReservationModel> get userReservations => _userReservations;
  MonthlyUsageModel? get currentMonthlyUsage => _currentMonthlyUsage;
  bool get isLoading => _isLoading;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get selectedTypeFilter => _selectedTypeFilter;
  String get selectedPriorityFilter => _selectedPriorityFilter;
  String get searchQuery => _searchQuery;

  List<PostModel> get urgentPosts =>
      _posts.where((p) => p.isEmergency || p.priority == 'high').toList();

  Future<void> fetchPosts({
    String? city,
    String? categoryId,
    String? type,
    String? priority,
    String? query,
  }) async {
    _isLoading = true;
    notifyListeners();

    if (categoryId != null) _selectedCategoryFilter = categoryId;
    if (type != null) _selectedTypeFilter = type;
    if (priority != null) _selectedPriorityFilter = priority;
    if (query != null) _searchQuery = query;

    _posts = await _postRepository.getPosts(
      city: city,
      categoryId: _selectedCategoryFilter,
      type: _selectedTypeFilter,
      priority: _selectedPriorityFilter,
      searchQuery: _searchQuery,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMonthlyUsage(String userId) async {
    _currentMonthlyUsage = await _postRepository.getMonthlyUsage(userId);
    notifyListeners();
  }

  Future<PostModel> createPost(PostModel post) async {
    final created = await _postRepository.createPost(post);
    await fetchPosts(city: post.city);
    await fetchMonthlyUsage(post.userId);
    return created;
  }

  Future<ReservationModel> reserveHelp({
    required PostModel post,
    required String reservedById,
    required String reservedByName,
    required int reservedQuantity,
    String note = '',
  }) async {
    final res = await _reservationRepository.createReservation(
      post: post,
      reservedById: reservedById,
      reservedByName: reservedByName,
      reservedQuantity: reservedQuantity,
      note: note,
    );

    await fetchPosts(city: post.city);
    await fetchUserReservations(reservedById);
    return res;
  }

  Future<void> fetchUserReservations(String userId) async {
    _userReservations = await _reservationRepository.getReservationsForUser(
      userId,
    );
    notifyListeners();
  }

  Future<void> cancelReservation(ReservationModel res, String city) async {
    await _reservationRepository.cancelReservation(res);
    await fetchPosts(city: city);
    await fetchUserReservations(res.reservedById);
  }

  Future<void> completeReservation(
    ReservationModel res,
    String userId,
    String city,
  ) async {
    await _reservationRepository.completeReservation(res, userId);
    await fetchPosts(city: city);
    await fetchUserReservations(userId);
  }

  Future<void> closePostEarly(String postId, String city) async {
    await _postRepository.closePostEarly(postId);
    await fetchPosts(city: city);
  }
}

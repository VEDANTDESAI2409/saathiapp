import 'package:flutter/material.dart';

import '../data/models/post_model.dart';
import '../data/models/reservation_model.dart';
import '../data/models/monthly_usage_model.dart';
import '../data/repositories/post_repository.dart';
import '../data/repositories/reservation_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  final ReservationRepository _reservationRepository = ReservationRepository();

  // Requirement 9: Isolated feed states
  List<PostModel> _homePosts = [];
  List<PostModel> _explorePosts = [];
  List<ReservationModel> _userReservations = [];
  MonthlyUsageModel? _currentMonthlyUsage;

  bool _isHomeLoading = false;
  bool _isExploreLoading = false;

  // Home filter state
  String _homeCategoryFilter = 'all';
  String _homeTypeFilter = 'all';
  String _homePriorityFilter = 'all';

  // Explore filter state
  String _exploreCategoryFilter = 'all';
  String _exploreTypeFilter = 'all';
  String _explorePriorityFilter = 'all';
  String _exploreSearchQuery = '';

  List<PostModel> get homePosts => _homePosts;
  List<PostModel> get explorePosts => _explorePosts;
  List<ReservationModel> get userReservations => _userReservations;
  MonthlyUsageModel? get currentMonthlyUsage => _currentMonthlyUsage;

  bool get isHomeLoading => _isHomeLoading;
  bool get isExploreLoading => _isExploreLoading;

  String get homeCategoryFilter => _homeCategoryFilter;
  String get homeTypeFilter => _homeTypeFilter;
  String get homePriorityFilter => _homePriorityFilter;

  String get exploreCategoryFilter => _exploreCategoryFilter;
  String get exploreTypeFilter => _exploreTypeFilter;
  String get explorePriorityFilter => _explorePriorityFilter;
  String get exploreSearchQuery => _exploreSearchQuery;

  List<PostModel> get urgentPosts => _homePosts
      .where(
        (p) =>
            (p.isEmergency || p.priority == 'high') && p.status != 'completed',
      )
      .toList();

  // Requirement 1: Home feed strictly filtered by user's preferred city
  Future<void> fetchHomePosts({
    required String preferredCity,
    String? categoryId,
    String? type,
    String? priority,
  }) async {
    _isHomeLoading = true;
    notifyListeners();

    if (categoryId != null) _homeCategoryFilter = categoryId;
    if (type != null) _homeTypeFilter = type;
    if (priority != null) _homePriorityFilter = priority;

    _homePosts = await _postRepository.getPosts(
      city: preferredCity,
      categoryId: _homeCategoryFilter,
      type: _homeTypeFilter,
      priority: _homePriorityFilter,
      includeCompleted: false, // Requirement 5
    );

    _isHomeLoading = false;
    notifyListeners();
  }

  // Requirement 1: Explore feed shows posts across ALL cities
  Future<void> fetchExplorePosts({
    String? categoryId,
    String? type,
    String? priority,
    String? query,
  }) async {
    _isExploreLoading = true;
    notifyListeners();

    if (categoryId != null) _exploreCategoryFilter = categoryId;
    if (type != null) _exploreTypeFilter = type;
    if (priority != null) _explorePriorityFilter = priority;
    if (query != null) _exploreSearchQuery = query;

    _explorePosts = await _postRepository.getPosts(
      city: 'All Cities', // Browse all cities
      categoryId: _exploreCategoryFilter,
      type: _exploreTypeFilter,
      priority: _explorePriorityFilter,
      searchQuery: _exploreSearchQuery,
      includeCompleted: false, // Requirement 5
    );

    _isExploreLoading = false;
    notifyListeners();
  }

  Future<void> fetchMonthlyUsage(String userId) async {
    _currentMonthlyUsage = await _postRepository.getMonthlyUsage(userId);
    notifyListeners();
  }

  Future<PostModel> createPost(PostModel post, String preferredCity) async {
    final created = await _postRepository.createPost(post);
    await fetchHomePosts(preferredCity: preferredCity);
    await fetchExplorePosts();
    await fetchMonthlyUsage(post.userId);
    return created;
  }

  Future<ReservationModel> reserveHelp({
    required PostModel post,
    required String reservedById,
    required String reservedByName,
    required String userPreferredCity,
    required int reservedQuantity,
    String note = '',
  }) async {
    final res = await _reservationRepository.createReservation(
      post: post,
      reservedById: reservedById,
      reservedByName: reservedByName,
      userPreferredCity: userPreferredCity,
      reservedQuantity: reservedQuantity,
      note: note,
    );

    await fetchHomePosts(preferredCity: userPreferredCity);
    await fetchExplorePosts();
    await fetchUserReservations(reservedById);
    return res;
  }

  Future<void> fetchUserReservations(String userId) async {
    _userReservations = await _reservationRepository.getReservationsForUser(
      userId,
    );
    notifyListeners();
  }

  Future<void> cancelReservation(
    ReservationModel res,
    String preferredCity,
  ) async {
    await _reservationRepository.cancelReservation(res);
    await fetchHomePosts(preferredCity: preferredCity);
    await fetchExplorePosts();
    await fetchUserReservations(res.reservedById);
  }

  Future<void> completeReservation({
    required ReservationModel res,
    required String userId,
    required String userName,
    required String photoUrl,
    required String preferredCity,
    String notes = '',
  }) async {
    await _reservationRepository.completeReservation(
      reservation: res,
      currentUserId: userId,
      currentUserName: userName,
      photoUrl: photoUrl,
      notes: notes,
    );

    await fetchHomePosts(preferredCity: preferredCity);
    await fetchExplorePosts();
    await fetchUserReservations(userId);
  }

  Future<void> closePostEarly(String postId, String preferredCity) async {
    await _postRepository.closePostEarly(postId);
    await fetchHomePosts(preferredCity: preferredCity);
    await fetchExplorePosts();
  }

  Future<void> reopenPost(String postId, String preferredCity) async {
    await _postRepository.reopenPost(postId);
    await fetchHomePosts(preferredCity: preferredCity);
    await fetchExplorePosts();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../providers/post_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/city_provider.dart';
import 'widgets/hero_slider.dart';
import 'widgets/service_category_strip.dart';
import 'widgets/urgent_needs_section.dart';
import 'widgets/post_card.dart';
import '../create/create_need_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);

    final preferredCity = cityProvider.selectedCity;
    final homePosts = postProvider.homePosts;
    final urgentPosts = postProvider.urgentPosts;

    return RefreshIndicator(
      onRefresh: () async {
        await postProvider.fetchHomePosts(preferredCity: preferredCity);
        await categoryProvider.loadCategoriesAndBanners();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Slider Banners (Includes Looping Helpline Slide)
            HeroSlider(banners: categoryProvider.banners),
            const SizedBox(height: 12),

            // 2. Service Categories Strip with Images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  if (postProvider.homeCategoryFilter != 'all')
                    TextButton(
                      onPressed: () {
                        postProvider.fetchHomePosts(
                          preferredCity: preferredCity,
                          categoryId: 'all',
                        );
                      },
                      child: const Text('Reset Filter'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            ServiceCategoryStrip(
              categories: categoryProvider.categories,
              selectedCategory: postProvider.homeCategoryFilter,
              onSelectCategory: (catId) {
                postProvider.fetchHomePosts(
                  preferredCity: preferredCity,
                  categoryId: catId,
                );
              },
            ),
            const SizedBox(height: 12),

            // 3. Urgent & Emergency Needs Section
            UrgentNeedsSection(urgentPosts: urgentPosts),
            const SizedBox(height: 12),

            // 4. Simplified Home Community Feed Header & Filter Buttons (Requirement 8)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Simplified Header (city name removed from header title)
                  const Text(
                    'Community Feed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const Spacer(),

                  // All 3 filter buttons made compact and responsive
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _compactTypeChip(
                        context,
                        label: 'All',
                        value: 'all',
                        selected: postProvider.homeTypeFilter == 'all',
                        preferredCity: preferredCity,
                      ),
                      const SizedBox(width: 4),
                      _compactTypeChip(
                        context,
                        label: 'Needs',
                        value: 'need',
                        selected: postProvider.homeTypeFilter == 'need',
                        preferredCity: preferredCity,
                      ),
                      const SizedBox(width: 4),
                      _compactTypeChip(
                        context,
                        label: 'Offers',
                        value: 'offer',
                        selected: postProvider.homeTypeFilter == 'offer',
                        preferredCity: preferredCity,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 5. Posts List (City-isolated for Preferred City)
            if (postProvider.isHomeLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (homePosts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateWidget(
                  title: 'No active requests in $preferredCity',
                  description:
                      'Be the first to post a request or offer assistance in $preferredCity!',
                  buttonLabel: 'Create Request / Offer',
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateNeedScreen(),
                      ),
                    );
                  },
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: homePosts.length,
                itemBuilder: (context, i) {
                  return PostCard(post: homePosts[i]);
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _compactTypeChip(
    BuildContext context, {
    required String label,
    required String value,
    required bool selected,
    required String preferredCity,
  }) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        postProvider.fetchHomePosts(preferredCity: preferredCity, type: value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.trustTeal : AppColors.softMint,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.deepForest,
            fontSize: 10,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

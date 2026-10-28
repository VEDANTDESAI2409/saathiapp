import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../providers/post_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/city_provider.dart';
import 'widgets/hero_slider.dart';
import 'widgets/service_category_strip.dart';
import 'widgets/urgent_needs_section.dart';
import 'widgets/post_card.dart';
import '../create/create_need_screen.dart';
import '../create/create_offer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);

    final city = cityProvider.selectedCity;
    final posts = postProvider.posts;
    final urgentPosts = postProvider.urgentPosts;

    return RefreshIndicator(
      onRefresh: () async {
        await postProvider.fetchPosts(city: city);
        await categoryProvider.loadCategoriesAndBanners();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Slider Banners
            HeroSlider(banners: categoryProvider.banners),
            const SizedBox(height: 16),

            // 2. Action Choice Buttons: "I Need Help" & "I Want to Help"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'I Need Help',
                      icon: Icons.volunteer_activism_outlined,
                      variant: AppButtonVariant.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateNeedScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'I Want to Help',
                      icon: Icons.handshake_outlined,
                      variant: AppButtonVariant.secondary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateOfferScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Service Categories Strip
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
                  if (postProvider.selectedCategoryFilter != 'all')
                    TextButton(
                      onPressed: () {
                        postProvider.fetchPosts(city: city, categoryId: 'all');
                      },
                      child: const Text('Reset Filter'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ServiceCategoryStrip(
              categories: categoryProvider.categories,
              selectedCategory: postProvider.selectedCategoryFilter,
              onSelectCategory: (catId) {
                postProvider.fetchPosts(city: city, categoryId: catId);
              },
            ),
            const SizedBox(height: 16),

            // 4. Urgent & Emergency Needs Section
            UrgentNeedsSection(urgentPosts: urgentPosts),
            const SizedBox(height: 16),

            // 5. City-Based Community Feed Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Community Feed ($city)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const Spacer(),
                  _typeFilterChip(
                    context,
                    label: 'All',
                    value: 'all',
                    selected: postProvider.selectedTypeFilter == 'all',
                  ),
                  const SizedBox(width: 4),
                  _typeFilterChip(
                    context,
                    label: 'Needs',
                    value: 'need',
                    selected: postProvider.selectedTypeFilter == 'need',
                  ),
                  const SizedBox(width: 4),
                  _typeFilterChip(
                    context,
                    label: 'Offers',
                    value: 'offer',
                    selected: postProvider.selectedTypeFilter == 'offer',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 6. Posts List
            if (postProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (posts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateWidget(
                  title: 'No Needs or Offers in $city yet',
                  description: 'Be the first to post a request or offer assistance in your city!',
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
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  return PostCard(post: posts[i]);
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _typeFilterChip(
    BuildContext context, {
    required String label,
    required String value,
    required bool selected,
  }) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final cityProvider = Provider.of<CityProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        postProvider.fetchPosts(city: cityProvider.selectedCity, type: value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.trustTeal : AppColors.softMint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.deepForest,
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

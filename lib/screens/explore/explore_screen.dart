import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../providers/post_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/city_provider.dart';
import '../home/widgets/post_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);

    final posts = postProvider.posts;
    final city = cityProvider.selectedCity;

    return Column(
      children: [
        // Search & Filter Header
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.warmCream,
          child: Column(
            children: [
              // Search Input Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search food, medicines, books in $city...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.trustTeal,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            postProvider.fetchPosts(city: city, query: '');
                          },
                        )
                      : null,
                ),
                onChanged: (val) {
                  postProvider.fetchPosts(city: city, query: val);
                },
              ),
              const SizedBox(height: 12),

              // Filter Dropdowns
              Row(
                children: [
                  // Category Dropdown Filter
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: postProvider.selectedCategoryFilter,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.deepForest,
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'all',
                              child: Text('All Categories'),
                            ),
                            ...categoryProvider.categories.map((c) {
                              return DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              );
                            }),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              postProvider.fetchPosts(
                                city: city,
                                categoryId: val,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Priority Dropdown Filter
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: postProvider.selectedPriorityFilter,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.deepForest,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text('All Priorities'),
                            ),
                            DropdownMenuItem(
                              value: 'emergency',
                              child: Text('Emergency Only'),
                            ),
                            DropdownMenuItem(
                              value: 'high',
                              child: Text('High Priority'),
                            ),
                            DropdownMenuItem(
                              value: 'normal',
                              child: Text('Normal Priority'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              postProvider.fetchPosts(
                                city: city,
                                priority: val,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Results Summary Line
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'Showing ${posts.length} results in $city',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (postProvider.selectedCategoryFilter != 'all' ||
                  postProvider.selectedPriorityFilter != 'all' ||
                  _searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    postProvider.fetchPosts(
                      city: city,
                      categoryId: 'all',
                      priority: 'all',
                      query: '',
                    );
                  },
                  child: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.trustTeal,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: postProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : posts.isEmpty
              ? const EmptyStateWidget(
                  title: 'No matching requests found',
                  description:
                      'Try adjusting your search query or filter criteria.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    return PostCard(post: posts[i]);
                  },
                ),
        ),
      ],
    );
  }
}

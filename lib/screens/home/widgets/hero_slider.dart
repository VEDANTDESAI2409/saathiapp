import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/config/app_config.dart';
import '../../../data/models/banner_model.dart';

class HeroSlider extends StatefulWidget {
  final List<BannerModel> banners;

  const HeroSlider({super.key, required this.banners});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.banners.isEmpty || !_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 165,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: widget.banners.length,
            itemBuilder: (context, i) {
              final banner = widget.banners[i];
              final isHelplineSlide = banner.actionType == 'helpline';
              final isHelplineConfigured = AppConfig.isHelplineConfigured();

              return GestureDetector(
                onTap: () async {
                  if (isHelplineSlide) {
                    if (isHelplineConfigured) {
                      final helpline = AppConfig.helplineNumber;
                      final Uri url = Uri.parse(
                        'tel:${helpline.replaceAll(' ', '')}',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Helpline number is not configured in current environment.',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(banner.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          isHelplineSlide
                              ? AppColors.trustTeal.withValues(alpha: 0.9)
                              : AppColors.deepForest.withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (isHelplineSlide) ...[
                              const Icon(
                                Icons.phone_in_talk,
                                color: AppColors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                banner.title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner.description,
                          style: const TextStyle(
                            color: AppColors.softMint,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isHelplineSlide) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isHelplineConfigured
                                  ? AppColors.warmOrange
                                  : AppColors.border,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isHelplineConfigured
                                  ? 'Tap to Call ${AppConfig.helplineNumber}'
                                  : 'Helpline Number Not Configured',
                              style: TextStyle(
                                color: isHelplineConfigured
                                    ? AppColors.deepForest
                                    : AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (idx) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == idx ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == idx
                    ? AppColors.trustTeal
                    : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

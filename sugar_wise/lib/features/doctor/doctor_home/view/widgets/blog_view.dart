import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';

class BlogPost {
  final String tagKey;
  final String title;
  final String subtitle;
  final String date;
  final String readTime;
  final Color tagBg;
  final Color tagText;
  final String categoryKey;

  BlogPost({
    required this.tagKey,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.readTime,
    required this.tagBg,
    required this.tagText,
    required this.categoryKey,
  });
}

final List<BlogPost> _allPosts = [
  BlogPost(
    tagKey: "research_cat",
    title: "Managing Childhood Diabetes During School",
    subtitle:
        "Practical tips for parents and teachers to help children manage diabetes during school hours",
    date: "April 10, 2024",
    readTime: "5 min read",
    tagBg: const Color(0xFFF3E8FF),
    tagText: const Color(0xFFA855F7),
    categoryKey: "research_cat",
  ),
  BlogPost(
    tagKey: "technology_cat",
    title: "Latest Advances in Glucose Monitoring",
    subtitle:
        "Review of new technologies in continuous glucose monitoring for pediatric patients",
    date: "March 25, 2024",
    readTime: "8 min read",
    tagBg: const Color(0xFFEFF6FF),
    tagText: const Color(0xFF3B82F6),
    categoryKey: "technology_cat",
  ),
  BlogPost(
    tagKey: "for_patients",
    title: "Nutrition Guide for Young Diabetics",
    subtitle:
        "Healthy eating habits and meal planning for children with diabetes",
    date: "March 15, 2024",
    readTime: "6 min read",
    tagBg: const Color(0xFFECFDF5),
    tagText: const Color(0xFF10B981),
    categoryKey: "for_patients",
  ),
  BlogPost(
    tagKey: "for_doctors",
    title: "Pediatric Diabetes: New Clinical Guidelines",
    subtitle:
        "Understanding the 2024 updates in clinical practice for young patients",
    date: "Feb 20, 2024",
    readTime: "10 min read",
    tagBg: const Color(0xFFF3E8FF),
    tagText: const Color(0xFFA855F7),
    categoryKey: "for_doctors",
  ),
  BlogPost(
    tagKey: "research_cat",
    title: "The Psychology of Childhood Diabetes",
    subtitle:
        "Understanding the emotional impact and providing psychological support",
    date: "February 28, 2024",
    readTime: "7 min read",
    tagBg: const Color(0xFFF3E8FF),
    tagText: const Color(0xFFA855F7),
    categoryKey: "research_cat",
  ),
];

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  // Store the filter as a category KEY (not translated text) to avoid locale mismatch
  String _selectedFilterKey = "all";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkTextPrimary : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "blog_title".tr(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "blog_subtitle".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkTextSecondary : Colors.black54,
              ),
            ),
            const SizedBox(height: 25),

            // Filter chips – compare keys, display translated text
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildFilterChip("all", isDark),
                _buildFilterChip("for_doctors", isDark),
                _buildFilterChip("for_patients", isDark),
                _buildFilterChip("research_cat", isDark),
                _buildFilterChip("technology_cat", isDark),
              ],
            ),
            const SizedBox(height: 30),

            // Filtered posts
            ..._allPosts
                .where(
                  (post) =>
                      _selectedFilterKey == "all" ||
                      post.categoryKey == _selectedFilterKey,
                )
                .map(
                  (post) => _buildBlogCard(
                    post.tagKey.tr(),
                    post.title,
                    post.subtitle,
                    post.date,
                    post.readTime,
                    isDark ? post.tagText.withValues(alpha: 0.1) : post.tagBg,
                    isDark ? post.tagText.withValues(alpha: 0.9) : post.tagText,
                    isDark,
                  ),
                ),

            if (_allPosts
                .where(
                  (post) =>
                      _selectedFilterKey == "all" ||
                      post.categoryKey == _selectedFilterKey,
                )
                .isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 60,
                      color: isDark ? Colors.white10 : Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "no_articles".tr(),
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                size: 18,
                color: isDark ? Colors.blue.shade300 : const Color(0xFF3B82F6),
              ),
              label: Text(
                "back_to_about".tr(),
                style: TextStyle(
                  color: isDark
                      ? Colors.blue.shade300
                      : const Color(0xFF3B82F6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, bool isDark) {
    final bool isSelected = _selectedFilterKey == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterKey = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB)
              : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          key.tr(),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.darkTextSecondary
                      : const Color(0xFF475569)),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBlogCard(
    String tag,
    String title,
    String subtitle,
    String date,
    String readTime,
    Color tagBg,
    Color tagText,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagText,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                readTime,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : const Color(0xFF1E2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : Colors.black54,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      "read_article".tr(),
                      style: TextStyle(
                        color: isDark
                            ? Colors.blue.shade300
                            : const Color(0xFF3B82F6),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: isDark
                          ? Colors.blue.shade300
                          : const Color(0xFF3B82F6),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class DetailSectionCard extends StatelessWidget {
  final String title;
  final List<DetailItem> items;
  final bool isDark;

  const DetailSectionCard({
    super.key,
    required this.title,
    required this.items,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out items with null or empty values
    final validItems = items.where((item) => item.value != null && item.value.toString().isNotEmpty).toList();
    
    if (validItems.isEmpty) {
      return const SizedBox.shrink();
    }

    // Map title to icon
    final IconData icon;
    if (title.contains('Specification')) {
      icon = Icons.info_outline;
    } else if (title.contains('Registration') || title.contains('Status')) {
      icon = Icons.verified_outlined;
    } else if (title.contains('Inspection')) {
      icon = Icons.check_circle_outline;
    } else if (title.contains('Listing')) {
      icon = Icons.calendar_today_outlined;
    } else {
      icon = Icons.description_outlined;
    }

    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: title == 'Vehicle Specifications' ? 26 : 16,
        bottom: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Detail items grid with modern styling
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: validItems.length,
            itemBuilder: (context, index) {
              final item = validItems[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withOpacity(0.05)
                      : AppColors.mutedBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailItem {
  final String label;
  final dynamic value;

  DetailItem({
    required this.label,
    required this.value,
  });
}

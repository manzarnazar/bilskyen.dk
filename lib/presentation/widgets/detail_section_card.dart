import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class DetailSectionCard extends StatefulWidget {
  final String title;
  final List<DetailItem> items;
  final bool isDark;
  final bool initiallyExpanded;

  const DetailSectionCard({
    super.key,
    required this.title,
    required this.items,
    required this.isDark,
    this.initiallyExpanded = true,
  });

  @override
  State<DetailSectionCard> createState() => _DetailSectionCardState();
}

class _DetailSectionCardState extends State<DetailSectionCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  IconData _getIcon() {
    if (widget.title.contains('Specification')) {
      return Icons.info_outline;
    } else if (widget.title.contains('Registration') || widget.title.contains('Status')) {
      return Icons.verified_outlined;
    } else if (widget.title.contains('Inspection')) {
      return Icons.check_circle_outline;
    } else if (widget.title.contains('Listing')) {
      return Icons.calendar_today_outlined;
    } else {
      return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out items with null or empty values
    final validItems = widget.items
        .where((item) => item.value != null && item.value.toString().isNotEmpty)
        .toList();

    if (validItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final icon = _getIcon();

    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: widget.title == 'Vehicle Specifications' ? 26 : 16,
        bottom: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title with icon - tappable to expand/collapse
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
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
                      widget.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: widget.isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isExpanded) ...[
                  const SizedBox(height: 12),
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
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.05)
                      : AppColors.mutedBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.isDark
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
                        color: widget.isDark ? AppColors.mutedDark : AppColors.mutedLight,
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
                        color: widget.isDark ? AppColors.textDark : AppColors.textLight,
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
              ],
            ),
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

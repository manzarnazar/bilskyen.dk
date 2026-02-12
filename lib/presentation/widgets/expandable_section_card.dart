import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// A card with an expandable/collapsible section.
/// Tap the header to toggle expansion.
class ExpandableSectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isDark;
  final bool initiallyExpanded;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;

  const ExpandableSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isDark,
    required this.child,
    this.initiallyExpanded = true,
    this.margin,
    this.decoration,
  });

  @override
  State<ExpandableSectionCard> createState() => _ExpandableSectionCardState();
}

class _ExpandableSectionCardState extends State<ExpandableSectionCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final defaultMargin = EdgeInsets.only(
      left: 20,
      right: 20,
      top: 16,
      bottom: 16,
    );
    final defaultDecoration = BoxDecoration(
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
    );

    return Container(
      margin: widget.margin ?? defaultMargin,
      padding: const EdgeInsets.all(16),
      decoration: widget.decoration ?? defaultDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      widget.icon,
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
                  widget.child,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

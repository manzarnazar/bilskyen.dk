import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../controllers/app_controller/app_controller.dart';

class _NavBarItemData {
  final String assetPath;
  final String label;

  const _NavBarItemData({required this.assetPath, required this.label});
}

const _barHeight = 56.0;
const _lineWidth = 24.0;
const _lineHeight = 3.0;

List<_NavBarItemData> _itemsFor(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    _NavBarItemData(assetPath: 'assets/icons/home.png', label: l10n.navHome),
    _NavBarItemData(assetPath: 'assets/icons/heart.png', label: l10n.navFavorites),
    _NavBarItemData(assetPath: 'assets/icons/search.png', label: l10n.navSearch),
    _NavBarItemData(assetPath: 'assets/icons/list.png', label: l10n.navMyListings),
    _NavBarItemData(assetPath: 'assets/icons/user.png', label: l10n.navProfile),
  ];
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final barColor = isDark ? AppColors.cardDark : AppColors.cardLight;
      final borderColor =
          isDark ? AppColors.borderDark : AppColors.borderLight;
      final selectedColor = AppColors.primary;
      final unselectedColor =
          isDark ? AppColors.mutedDark : AppColors.mutedLight;

      return Container(
        decoration: BoxDecoration(
          color: barColor,
          border: Border(top: BorderSide(color: borderColor)),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: _barHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _itemsFor(context).length; i++)
                  Expanded(
                    child: _RegularNavItem(
                      item: _itemsFor(context)[i],
                      isSelected: currentIndex == i,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _RegularNavItem extends StatelessWidget {
  final _NavBarItemData item;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _RegularNavItem({
    required this.item,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Container(
              width: _lineWidth,
              height: _lineHeight,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(_lineHeight / 2),
              ),
            ),
          Image.asset(
            item.assetPath,
            width: 24,
            height: 24,
            color: color,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}


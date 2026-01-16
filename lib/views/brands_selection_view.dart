import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../services/mock_lookup_service.dart';
import '../models/brand_model.dart';

class BrandsSelectionView extends StatefulWidget {
  const BrandsSelectionView({super.key});

  @override
  State<BrandsSelectionView> createState() => _BrandsSelectionViewState();
}

class _BrandsSelectionViewState extends State<BrandsSelectionView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();
    final allBrands = MockLookupService.getBrands();
    
    // Filter brands based on search query
    final filteredBrands = _searchQuery.isEmpty
        ? allBrands
        : allBrands.where((brand) =>
            brand.name.toLowerCase().contains(_searchQuery)).toList();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            onPressed: () => Get.back(),
          ),
          title: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            autofocus: true,
            style: TextStyle(
              color: isDark ? AppColors.textDark : AppColors.textLight,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search brands...',
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.mutedDark
                    : AppColors.mutedLight,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          actions: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
                onPressed: () {
                  _searchController.clear();
                },
              ),
          ],
        ),
        body: Column(
          children: [
            // All Brands List
            Expanded(
              child: filteredBrands.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No brands found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredBrands.length,
                      itemBuilder: (context, index) {
                        final brand = filteredBrands[index];
                        return Obx(() {
                          final isSelected = controller.selectedBrandIds.contains(brand.id);
                          return _buildBrandListItem(
                            brand: brand,
                            isSelected: isSelected,
                            onTap: () {
                              controller.toggleBrand(brand.id);
                            },
                            isDark: isDark,
                          );
                        });
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBrandListItem({
    required BrandModel brand,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1))
              : (isDark ? AppColors.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                brand.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: isDark ? Colors.white : Colors.black,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}


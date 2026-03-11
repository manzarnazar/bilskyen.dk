import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/search_controller.dart' as search_controller;
import '../../services/constants_service.dart';

/// Full-screen sub view for selecting a vehicle brand in search filters.
class BrandSelectorView extends StatefulWidget {
  const BrandSelectorView({super.key});

  @override
  State<BrandSelectorView> createState() => _BrandSelectorViewState();
}

class _BrandSelectorViewState extends State<BrandSelectorView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final l10n = AppLocalizations.of(context)!;
    final cs = Get.find<ConstantsService>();
    final brands = cs.getBrands();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final query = _searchController.text.trim().toLowerCase();
      final filteredBrands = query.isEmpty
          ? brands
          : brands.where((b) => b.name.toLowerCase().contains(query)).toList();

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
          elevation: 0,
          title: Text(
            l10n.brand,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.backgroundDark : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray400, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  prefixIcon: Icon(Icons.search, color: isDark ? AppColors.mutedDark : AppColors.mutedLight, size: 24),
                ),
              ),
            ),
            Expanded(
              child: brands.isEmpty
                  ? Center(
                      child: Text(
                        l10n.loadingFilters,
                        style: TextStyle(
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                        ),
                      ),
                    )
                      : filteredBrands.isEmpty
                      ? Center(
                          child: Text(
                            'No brands found',
                            style: TextStyle(
                              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredBrands.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildBrandTile(
                                context,
                                isDark,
                                label: l10n.all,
                                brandId: null,
                              );
                            }
                            final brand = filteredBrands[index - 1];
                            return _buildBrandTile(
                              context,
                              isDark,
                              label: brand.name,
                              brandId: brand.id,
                            );
                          },
                        ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBrandTile(
    BuildContext context,
    bool isDark, {
    required String label,
    required int? brandId,
  }) {
    final searchController = Get.find<search_controller.SearchViewController>();
    final selectedBrandId = searchController.brandId.value;
    final isSelected = selectedBrandId == brandId;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          searchController.brandId.value = brandId;
          searchController.modelId.value = null;
          Get.back();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primary30 : AppColors.primary10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

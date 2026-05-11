import 'dart:async';

import 'package:bilskyen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/search_controller.dart' as search_controller;
import '../../models/constants_model/constants_model.dart';
import '../../services/constants_service.dart';
import '../../utils/app_colors.dart';

enum SearchLookupType { brand, model, variant }

class SearchLookupPickerView extends StatefulWidget {
  final SearchLookupType type;

  const SearchLookupPickerView({
    super.key,
    required this.type,
  });

  @override
  State<SearchLookupPickerView> createState() => _SearchLookupPickerViewState();
}

class _SearchLookupPickerViewState extends State<SearchLookupPickerView> {
  late final search_controller.SearchViewController searchController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int _requestToken = 0;
  bool _isLoading = false;
  List<LookupItem> _items = const <LookupItem>[];

  @override
  void initState() {
    super.initState();
    searchController = Get.find<search_controller.SearchViewController>();
    _fetchItems();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleLookup() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _fetchItems);
  }

  Future<void> _fetchItems() async {
    if (!_canSearchCurrentType()) {
      if (mounted) {
        setState(() {
          _items = const <LookupItem>[];
          _isLoading = false;
        });
      }
      return;
    }

    final token = ++_requestToken;
    setState(() => _isLoading = true);
    final constants = Get.find<ConstantsService>();
    final query = _searchController.text.trim();

    List<LookupItem> fetched;
    switch (widget.type) {
      case SearchLookupType.brand:
        fetched = await constants.searchBrands(search: query, limit: 25);
        break;
      case SearchLookupType.model:
        final models = await constants.searchListingModels(
          search: query,
          brandIds: searchController.selectedBrandIds.toList(),
          limit: 25,
        );
        fetched = models.map((e) => LookupItem(id: e.id, name: e.name)).toList();
        break;
      case SearchLookupType.variant:
        final variants = await constants.searchVariants(
          search: query,
          modelIds: searchController.selectedModelIds.toList(),
          limit: 25,
        );
        fetched = variants.map((e) => LookupItem(id: e.id, name: e.name)).toList();
        break;
    }

    if (!mounted || token != _requestToken) return;

    final merged = <LookupItem>[...fetched];
    final selectedIds = _selectedIds;
    final selectedNames = _selectedNames;
    for (final id in selectedIds) {
      final name = selectedNames[id];
      if (name != null && merged.every((e) => e.id != id)) {
        merged.insert(0, LookupItem(id: id, name: name));
      }
    }

    setState(() {
      _items = merged;
      _isLoading = false;
    });
  }

  bool _canSearchCurrentType() {
    switch (widget.type) {
      case SearchLookupType.brand:
        return true;
      case SearchLookupType.model:
        return searchController.selectedBrandIds.isNotEmpty;
      case SearchLookupType.variant:
        return searchController.selectedModelIds.isNotEmpty;
    }
  }

  List<int> get _selectedIds {
    switch (widget.type) {
      case SearchLookupType.brand:
        return searchController.selectedBrandIds;
      case SearchLookupType.model:
        return searchController.selectedModelIds;
      case SearchLookupType.variant:
        return searchController.selectedVariantIds;
    }
  }

  Map<int, String> get _selectedNames {
    switch (widget.type) {
      case SearchLookupType.brand:
        return searchController.selectedBrandNames;
      case SearchLookupType.model:
        return searchController.selectedModelNames;
      case SearchLookupType.variant:
        return searchController.selectedVariantNames;
    }
  }

  void _toggleSelection(LookupItem item) {
    final selected = _selectedIds.contains(item.id);
    switch (widget.type) {
      case SearchLookupType.brand:
        if (selected) {
          searchController.selectedBrandIds.remove(item.id);
          searchController.selectedBrandNames.remove(item.id);
          searchController.selectedModelIds.clear();
          searchController.selectedModelNames.clear();
          searchController.selectedVariantIds.clear();
          searchController.selectedVariantNames.clear();
          searchController.brandId.value = null;
          searchController.modelId.value = null;
        } else {
          searchController.selectedBrandIds.add(item.id);
          searchController.selectedBrandNames[item.id] = item.name;
          searchController.brandId.value = null;
        }
        break;
      case SearchLookupType.model:
        if (selected) {
          searchController.selectedModelIds.remove(item.id);
          searchController.selectedModelNames.remove(item.id);
          searchController.selectedVariantIds.clear();
          searchController.selectedVariantNames.clear();
          searchController.modelId.value = null;
        } else {
          searchController.selectedModelIds.add(item.id);
          searchController.selectedModelNames[item.id] = item.name;
          searchController.modelId.value = null;
        }
        break;
      case SearchLookupType.variant:
        if (selected) {
          searchController.selectedVariantIds.remove(item.id);
          searchController.selectedVariantNames.remove(item.id);
        } else {
          searchController.selectedVariantIds.add(item.id);
          searchController.selectedVariantNames[item.id] = item.name;
        }
        break;
    }
    setState(() {});
  }

  String _title(AppLocalizations l10n) {
    switch (widget.type) {
      case SearchLookupType.brand:
        return l10n.brand;
      case SearchLookupType.model:
        return l10n.model;
      case SearchLookupType.variant:
        return l10n.variant;
    }
  }

  String? _blockedHint(AppLocalizations l10n) {
    switch (widget.type) {
      case SearchLookupType.brand:
        return null;
      case SearchLookupType.model:
      case SearchLookupType.variant:
        return l10n.selectBrandFirst;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final l10n = AppLocalizations.of(context)!;
    final canSearch = _canSearchCurrentType();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
          elevation: 0,
          title: Text(
            _title(l10n),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                enabled: canSearch,
                onChanged: (_) => _scheduleLookup(),
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
            if (_isLoading) const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: !canSearch
                  ? Center(
                      child: Text(
                        _blockedHint(l10n) ?? '',
                        style: TextStyle(
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                        ),
                      ),
                    )
                  : _items.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noResultsFound,
                            style: TextStyle(
                              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final checked = _selectedIds.contains(item.id);
                            return CheckboxListTile(
                              dense: true,
                              value: checked,
                              onChanged: (_) => _toggleSelection(item),
                              title: Text(
                                item.name,
                                style: TextStyle(color: isDark ? AppColors.textDark : AppColors.textLight),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primaryForeground,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(l10n.apply),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../models/vehicle_model/vehicle_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../main.dart';
import '../vehicle/widgets/enquiry_form_bottom_sheet.dart';
import 'cached_image.dart';

class VehicleCard extends StatefulWidget {
  final VehicleModel vehicle;
  final bool isDark;
  final bool isHorizontalLayout;
  /// When false, skips the favorites/check API call (e.g. on search, favorites, messages, profile).
  final bool checkFavoriteOnLoad;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isDark,
    this.isHorizontalLayout = false,
    this.checkFavoriteOnLoad = true,
  });

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  late FavoriteController _favoriteController;
  bool _isLoggedIn = false;

  int? get _currentUserId {
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      final id = authController.currentUser.value?.id;
      if (id != null) return id;
    }

    final userRaw = appStorage.read('user');
    if (userRaw == null) return null;
    try {
      final userMap = jsonDecode(userRaw.toString());
      if (userMap is Map<String, dynamic>) {
        final rawId = userMap['id'];
        if (rawId is int) return rawId;
        if (rawId is num) return rawId.toInt();
        return int.tryParse(rawId?.toString() ?? '');
      }
    } catch (_) {}
    return null;
  }

  bool get _isOwnVehicle {
    final ownerId = widget.vehicle.userId;
    final currentUserId = _currentUserId;
    return ownerId != null && currentUserId != null && ownerId == currentUserId;
  }

  @override
  void initState() {
    super.initState();
    _favoriteController = Get.put(FavoriteController());
    _checkLoginStatus();
    // Defer API call until after build phase completes (only when allowed for this screen)
    if (widget.checkFavoriteOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkFavoriteStatus();
      });
    }
  }

  void _checkLoginStatus() {
    final token = appStorage.read('token');
    setState(() {
      _isLoggedIn = token != null && token.toString().isNotEmpty;
    });
  }

  void _checkFavoriteStatus() {
    if (_isLoggedIn && widget.checkFavoriteOnLoad) {
      _favoriteController.checkFavoriteStatus(widget.vehicle.id);
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Get.dialog(
      AlertDialog(
        title: Text(l10n.loginRequired),
        content: Text(l10n.pleaseSignInToListVehicle),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.primaryForeground,
            ),
            child: Text(l10n.logIn),
          ),
        ],
      ),
    );
  }

  void _handleFavoriteToggle(BuildContext context) {
    if (!_isLoggedIn) {
      _showLoginRequiredDialog(context);
      return;
    }
    _favoriteController.toggleFavorite(widget.vehicle.id);
  }

  void _handleEnquireTap(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    Get.bottomSheet(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: EnquiryFormBottomSheet(
          vehicleId: widget.vehicle.id,
          vehicleTitle: widget.vehicle.title,
          type: EnquiryFormType.enquiry,
          brandName: widget.vehicle.brandName,
          modelName: widget.vehicle.modelName,
          price: widget.vehicle.price,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Format price with commas and "kr." suffix
  String _formatPrice(int price) {
    final priceString = price.toString();
    if (priceString.length <= 3) {
      return '$priceString kr.';
    }

    final reversed = priceString.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(reversed[i]);
    }

    return '${buffer.toString().split('').reversed.join()} kr.';
  }

  /// Format date from "2004-11-01" to "Nov 2004"
  String _formatRegistrationDate(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      final parts = dateString.split('-');
      if (parts.length >= 2) {
        final year = parts[0];
        final month = int.tryParse(parts[1]);
        
        if (month != null && month >= 1 && month <= 12) {
          const monthNames = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          return '${monthNames[month - 1]} $year';
        }
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  /// Format mileage with thousand separators. Requires context for localized N/A.
  String _formatMileage(BuildContext context, int? mileage) {
    if (mileage == null) return AppLocalizations.of(context)!.na;
    final mileageString = mileage.toString();
    if (mileageString.length <= 3) {
      return mileageString;
    }

    final reversed = mileageString.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(reversed[i]);
    }

    return buffer.toString().split('').reversed.join();
  }

  /// Pill badge for seller type (Private = orange, Dealer / null = blue)
  Widget _buildSellerTypeBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rawType = widget.vehicle.sellerType?.trim().toLowerCase() ?? '';
    final isPrivate = rawType == 'private';
    final sellerBackgroundColor =
        isPrivate ? AppColors.sellerTypePrivate : AppColors.primary60;
    final sellerLabel = isPrivate ? l10n.private : l10n.dealer;
    final salesTypeLabel = widget.vehicle.salesTypeName;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: sellerBackgroundColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            sellerLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryForeground,
            ),
          ),
        ),
        if (salesTypeLabel != null && salesTypeLabel.trim().isNotEmpty) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withOpacity(0.6),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              salesTypeLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryForeground,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isHorizontalLayout) {
      return _buildHorizontalLayout(context);
    }
    return _buildVerticalLayout(context);
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!widget.isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: Image on left, Details on right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section (40% width)
              Expanded(
                flex: 4,
                child: _buildHorizontalImage(context),
              ),
              // Details section (60% width)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title + optional version (subtitle)
                      Text(
                        widget.vehicle.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.vehicle.version != null &&
                          widget.vehicle.version!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.vehicle.version!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: widget.isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      // Price
                      Text(
                        _formatPrice(widget.vehicle.price),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Tags
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          if (widget.vehicle.kmDriven != null)
                            _buildTag('${_formatMileage(context, widget.vehicle.kmDriven)} km'),
                          if (widget.vehicle.enginePowerHp != null && widget.vehicle.enginePowerHp! > 0)
                            _buildTag('${widget.vehicle.enginePowerHp!.toStringAsFixed(0)} HP'),
                          if (widget.vehicle.firstRegistrationDate.isNotEmpty)
                            _buildTag(_formatRegistrationDate(widget.vehicle.firstRegistrationDate)),
                          if (widget.vehicle.gearTypeName != null && widget.vehicle.gearTypeName!.isNotEmpty)
                            _buildTag(widget.vehicle.gearTypeName!),
                          if (widget.vehicle.fuelTypeName != null && widget.vehicle.fuelTypeName!.isNotEmpty)
                            _buildTag(widget.vehicle.fuelTypeName!),
                          if (widget.vehicle.modelYearName != null && widget.vehicle.modelYearName!.isNotEmpty)
                            _buildTag(widget.vehicle.modelYearName!),
                        ],
                      ),
                      if (widget.vehicle.sellerAddress != null ||
                          widget.vehicle.sellerPostcode != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: widget.isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                [
                                  if (widget.vehicle.sellerAddress != null &&
                                      widget.vehicle.sellerAddress!.isNotEmpty)
                                    widget.vehicle.sellerAddress!,
                                  if (widget.vehicle.sellerPostcode != null &&
                                      widget.vehicle.sellerPostcode!.isNotEmpty)
                                    widget.vehicle.sellerPostcode!,
                                ].join(', '),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.isDark
                                      ? AppColors.textDark
                                      : AppColors.textLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Buttons
                      Row(
                        children: [
                          // View Details button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/vehicle-detail/${widget.vehicle.id}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.primaryForeground,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                minimumSize: const Size(0, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                l10n.viewDetails,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          if (!_isOwnVehicle) ...[
                            const SizedBox(width: 8),
                            // Enquire button
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _handleEnquireTap(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: widget.isDark
                                      ? AppColors.textDark
                                      : AppColors.textLight,
                                  side: BorderSide(
                                    color: widget.isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  minimumSize: const Size(0, 32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  l10n.enquire,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!widget.isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with heart icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: _buildVehicleImage(),
              ),
              // Seller type pill badge (top-left)
              Positioned(
                top: 12,
                left: 12,
                child: _buildSellerTypeBadge(context),
              ),
              // Heart icon in top right (only show if logged in)
              if (_isLoggedIn)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Obx(() {
                    final isFavorite = _favoriteController.isFavorite(widget.vehicle.id);
                    final isLoading = _favoriteController.isLoading(widget.vehicle.id);
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.black,
                                size: 18,
                              ),
                        onPressed: isLoading ? null : () => _handleFavoriteToggle(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    );
                  }),
                ),
            ],
          ),
          
          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + optional version (subtitle) to match web card
                Text(
                  widget.vehicle.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark
                        ? AppColors.textDark
                        : AppColors.textLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.vehicle.version != null &&
                    widget.vehicle.version!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.vehicle.version!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: widget.isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),

                // Price
                Text(
                  _formatPrice(widget.vehicle.price),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (widget.vehicle.kmDriven != null)
                      _buildTag('${_formatMileage(context, widget.vehicle.kmDriven)} km'),
                    if (widget.vehicle.enginePowerHp != null && widget.vehicle.enginePowerHp! > 0)
                      _buildTag('${widget.vehicle.enginePowerHp!.toStringAsFixed(0)} HP'),
                    if (widget.vehicle.firstRegistrationDate.isNotEmpty)
                      _buildTag(_formatRegistrationDate(widget.vehicle.firstRegistrationDate)),
                    if (widget.vehicle.gearTypeName != null && widget.vehicle.gearTypeName!.isNotEmpty)
                      _buildTag(widget.vehicle.gearTypeName!),
                    if (widget.vehicle.fuelTypeName != null && widget.vehicle.fuelTypeName!.isNotEmpty)
                      _buildTag(widget.vehicle.fuelTypeName!),
                    if (widget.vehicle.modelYearName != null && widget.vehicle.modelYearName!.isNotEmpty)
                      _buildTag(widget.vehicle.modelYearName!),
                  ],
                ),
                if (widget.vehicle.sellerAddress != null ||
                    widget.vehicle.sellerPostcode != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: widget.isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          [
                            if (widget.vehicle.sellerAddress != null &&
                                widget.vehicle.sellerAddress!.isNotEmpty)
                              widget.vehicle.sellerAddress!,
                            if (widget.vehicle.sellerPostcode != null &&
                                widget.vehicle.sellerPostcode!.isNotEmpty)
                              widget.vehicle.sellerPostcode!,
                          ].join(', '),
                          style: TextStyle(
                            fontSize: 13,
                            color: widget.isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                
                // Buttons
                Row(
                  children: [
                    // View Details button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/vehicle-detail/${widget.vehicle.id}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primaryForeground,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.viewDetails,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (!_isOwnVehicle) ...[
                      const SizedBox(width: 12),
                      // Enquire button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handleEnquireTap(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: widget.isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                            side: BorderSide(
                              color: widget.isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.enquire,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: widget.isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: widget.isDark ? AppColors.mutedDark : AppColors.mutedLight,
        ),
      ),
    );
  }

  Widget _buildHorizontalImage(BuildContext context) {
    final imageUrl = widget.vehicle.imageUrl;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          child: imageUrl.isEmpty
              ? Container(
                  height: 150,
                  width: double.infinity,
                  color: AppColors.carPlaceholderBg,
                  child: const Center(
                    child: Icon(Icons.directions_car, size: 60, color: AppColors.gray400),
                  ),
                )
              : SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: CustomCachedImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                  ),
                ),
        ),
        // Seller type pill badge (top-left)
        Positioned(
          top: 8,
          left: 8,
          child: _buildSellerTypeBadge(context),
        ),
        // Heart icon in bottom right of image (only show if logged in)
        if (_isLoggedIn)
          Positioned(
            bottom: 8,
            right: 8,
            child: Obx(() {
              final isFavorite = _favoriteController.isFavorite(widget.vehicle.id);
              final isLoading = _favoriteController.isLoading(widget.vehicle.id);
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                          size: 16,
                        ),
                  onPressed: isLoading ? null : () => _handleFavoriteToggle(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildVehicleImage() {
    final imageUrl = widget.vehicle.imageUrl;

    if (imageUrl.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        color: AppColors.carPlaceholderBg,
        child: const Center(
          child: Icon(Icons.directions_car, size: 80, color: AppColors.gray400),
        ),
      );
    }

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomCachedImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      ),
    );
  }
}

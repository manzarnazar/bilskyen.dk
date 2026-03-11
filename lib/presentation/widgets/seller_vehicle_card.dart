import 'package:flutter/material.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../models/vehicle_model/vehicle_model.dart';
import 'cached_image.dart';

class SellerVehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onInquiries;
  final VoidCallback onPublish;
  final VoidCallback onUnpublish;
  final VoidCallback onDelete;
  final bool isPublished;

  const SellerVehicleCard({
    super.key,
    required this.vehicle,
    required this.isDark,
    required this.onEdit,
    required this.onInquiries,
    required this.onPublish,
    required this.onUnpublish,
    required this.onDelete,
    required this.isPublished,
  });

  String _formatPrice(int price) {
    final s = price.toString();
    if (s.length <= 3) return '$s kr.';
    final reversed = s.split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) buffer.write(',');
      buffer.write(reversed[i]);
    }
    return '${buffer.toString().split('').reversed.join()} kr.';
  }

  String _formatRegistrationDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final parts = dateString.split('-');
      if (parts.length >= 2) {
        final year = parts[0];
        final month = int.tryParse(parts[1]);
        if (month != null && month >= 1 && month <= 12) {
          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          return '${months[month - 1]} $year';
        }
      }
      return dateString;
    } catch (_) {
      return dateString;
    }
  }

  String _formatMileage(int? mileage) {
    if (mileage == null) return 'N/A';
    final s = mileage.toString();
    if (s.length <= 3) return s;
    final reversed = s.split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) buffer.write('.');
      buffer.write(reversed[i]);
    }
    return buffer.toString().split('').reversed.join();
  }

  Color _statusColor() {
    switch (vehicle.vehicleListStatusId) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  bool get _hasLocation {
    final addr = vehicle.sellerAddress?.trim() ?? '';
    final post = vehicle.sellerPostcode?.trim() ?? '';
    return addr.isNotEmpty || post.isNotEmpty;
  }

  String get _locationText {
    final addr = vehicle.sellerAddress?.trim() ?? '';
    final post = vehicle.sellerPostcode?.trim() ?? '';
    if (addr.isNotEmpty && post.isNotEmpty) return '$addr, $post';
    if (addr.isNotEmpty) return addr;
    return post;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: vehicle.imageUrl.isEmpty
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        color: AppColors.carPlaceholderBg,
                        child: const Center(
                          child: Icon(Icons.directions_car, size: 80, color: AppColors.gray400),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: CustomCachedImage(
                          imageUrl: vehicle.imageUrl,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    vehicle.vehicleListStatusName ?? l10n.draft,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatPrice(vehicle.price),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (vehicle.kmDriven != null)
                      _tag('${_formatMileage(vehicle.kmDriven)} km'),
                    if (vehicle.enginePowerHp != null && vehicle.enginePowerHp! > 0)
                      _tag('${vehicle.enginePowerHp!.toStringAsFixed(0)} HP'),
                    if (vehicle.firstRegistrationDate.isNotEmpty)
                      _tag(_formatRegistrationDate(vehicle.firstRegistrationDate)),
                    if (vehicle.gearTypeName != null && vehicle.gearTypeName!.isNotEmpty)
                      _tag(vehicle.gearTypeName!),
                    if (vehicle.fuelTypeName != null && vehicle.fuelTypeName!.isNotEmpty)
                      _tag(vehicle.fuelTypeName!),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 14, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
                    const SizedBox(width: 4),
                    Text(
                      l10n.viewsCount(vehicle.viewsCount ?? 0),
                      style: TextStyle(fontSize: 12, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.chat_bubble_outline, size: 14, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
                    const SizedBox(width: 4),
                    Text(
                      l10n.inquiriesCount(vehicle.enquiriesCount ?? 0),
                      style: TextStyle(fontSize: 12, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(l10n.edit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primaryForeground,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onInquiries,
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: Text(l10n.inquiriesWithCount(vehicle.enquiriesCount ?? 0)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
                          side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: isPublished
                          ? OutlinedButton.icon(
                              onPressed: onUnpublish,
                              icon: const Icon(Icons.visibility_off, size: 18),
                              label: Text(l10n.unpublish),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange,
                                side: const BorderSide(color: Colors.orange),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            )
                          : OutlinedButton.icon(
                              onPressed: onPublish,
                              icon: const Icon(Icons.publish, size: 18),
                              label: Text(l10n.publish),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: const BorderSide(color: Colors.green),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(l10n.delete),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.destructive,
                          side: const BorderSide(color: AppColors.destructive),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_hasLocation) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _locationText,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textDark : AppColors.textLight,
        ),
      ),
    );
  }
}

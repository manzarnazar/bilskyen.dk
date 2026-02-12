import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/my_listings_controller.dart';
import '../../models/vehicle_model/vehicle_model.dart';
import '../../models/seller/inquiry_model.dart';
import '../../repositories/seller/seller_repository.dart';
import '../widgets/seller_vehicle_card.dart';

class MyListingsView extends StatelessWidget {
  const MyListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final controller = Get.put(MyListingsController());

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          foregroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: AppColors.primary),
          elevation: 0,
          automaticallyImplyLeading: Navigator.canPop(context),
          title: Text(
            'My Listings',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatistics(controller, isDark),
                      const SizedBox(height: 24),
                      _buildStatusTabs(controller, isDark),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Vehicles',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                          Obx(() {
                            final total = controller.totalDocs.value;
                            return Text(
                              '$total vehicles',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.isLoadingVehicles.value && controller.vehicles.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (controller.vehiclesError.value.isNotEmpty && controller.vehicles.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          controller.vehiclesError.value,
                          style: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                if (controller.vehicles.isEmpty) {
                  return SliverToBoxAdapter(
                    child: _buildEmptyState(isDark),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == controller.vehicles.length) {
                          if (controller.hasNextPage.value) {
                            controller.loadMore();
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return const SizedBox.shrink();
                        }
                        final vehicle = controller.vehicles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SellerVehicleCard(
                            vehicle: vehicle,
                            isDark: isDark,
                            onEdit: () => Get.toNamed('/edit-vehicle/${vehicle.id}'),
                            onInquiries: () => _showInquiriesSheet(context, controller, vehicle.id, isDark),
                            onPublish: () => controller.updateVehicleStatus(vehicle.id, VehicleListStatus.published),
                            onUnpublish: () => controller.updateVehicleStatus(vehicle.id, VehicleListStatus.draft),
                            onDelete: () => _confirmDelete(context, controller, vehicle),
                            isPublished: vehicle.vehicleListStatusId == VehicleListStatus.published,
                          ),
                        );
                      },
                      childCount: controller.vehicles.length + (controller.hasNextPage.value ? 1 : 0),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatistics(MyListingsController controller, bool isDark) {
    return Obx(() {
      if (controller.isLoadingStats.value) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.statsError.value.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Text(
            controller.statsError.value,
            style: TextStyle(color: AppColors.destructive, fontSize: 14),
          ),
        );
      }
      final stats = controller.statistics.value!;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(
          children: [
            Expanded(child: _statTile('Vehicles', '${stats.totalVehicles}', Icons.directions_car, isDark)),
            Expanded(child: _statTile('Worth', _formatWorth(stats.totalWorth), Icons.attach_money, isDark)),
            Expanded(child: _statTile('Inquiries', '${stats.totalInquiries}', Icons.chat_bubble_outline, isDark)),
            Expanded(child: _statTile('Views', '${stats.totalViews}', Icons.visibility_outlined, isDark)),
          ],
        ),
      );
    });
  }

  Widget _statTile(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
        ),
      ],
    );
  }

  String _formatWorth(int worth) {
    if (worth >= 1000000) return '${(worth / 1000000).toStringAsFixed(1)}M';
    if (worth >= 1000) return '${(worth / 1000).toStringAsFixed(0)}k';
    return worth.toString();
  }

  Widget _buildStatusTabs(MyListingsController controller, bool isDark) {
    final filters = [
      (null, 'All'),
      (VehicleListStatus.published, 'Published'),
      (VehicleListStatus.draft, 'Draft'),
      (VehicleListStatus.sold, 'Sold'),
      (VehicleListStatus.archived, 'Archived'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final id = f.$1;
          final label = f.$2;
          final selected = controller.selectedStatusFilter.value == id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: selected,
              onSelected: (_) => controller.setStatusFilter(id),
              selectedColor: AppColors.primary.withOpacity(0.3),
              checkmarkColor: AppColors.primary,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.directions_car_outlined, size: 64, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
          const SizedBox(height: 16),
          Text(
            'No vehicles yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'List your first vehicle to get started.',
            style: TextStyle(fontSize: 14, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/sell-your-car'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.primaryForeground,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('List your first vehicle'),
          ),
        ],
      ),
    );
  }

  void _showInquiriesSheet(BuildContext context, MyListingsController controller, int vehicleId, bool isDark) {
    Get.bottomSheet(
      _InquiriesBottomSheet(vehicleId: vehicleId, isDark: isDark),
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, MyListingsController controller, VehicleModel vehicle) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete vehicle'),
        content: Text('Delete "${vehicle.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await controller.deleteVehicle(vehicle.id);
    }
  }
}

/// Vehicle Inquiries bottom sheet – card layout with sender, date, type, subject, message preview
class _InquiriesBottomSheet extends StatelessWidget {
  final int vehicleId;
  final bool isDark;

  const _InquiriesBottomSheet({required this.vehicleId, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return FutureBuilder<List<InquiryModel>>(
          future: _loadInquiries(vehicleId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load inquiries: ${snapshot.error}',
                  style: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
                ),
              );
            }
            final list = snapshot.data ?? <InquiryModel>[];
            final count = list.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 8, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle Inquiries',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textDark : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              count == 1
                                  ? '1 inquiry for this vehicle'
                                  : '$count inquiries for this vehicle',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                // List
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text(
                            'No inquiries yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _InquiryCard(
                                inquiry: list[i],
                                isDark: isDark,
                                onTap: () => _showInquiryDetail(context, list[i].id, isDark),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<InquiryModel>> _loadInquiries(int vehicleId) async {
    final repo = SellerRepository();
    final result = await repo.getInquiries(vehicleId: vehicleId, limit: 50);
    return result.fold((_) => <InquiryModel>[], (r) => r.inquiries);
  }

  Future<void> _showInquiryDetail(BuildContext context, int inquiryId, bool isDark) async {
    final repo = SellerRepository();
    final result = await repo.getInquiry(inquiryId);
    result.fold(
      (err) => Get.snackbar('Error', err),
      (inquiry) {
        final dateStr = _InquiryCard._formatDate(inquiry.createdAt);
        Get.dialog(
          AlertDialog(
            title: Text(inquiry.displayName),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (inquiry.vehicleTitle != null && inquiry.vehicleTitle!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        inquiry.vehicleTitle!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ),
                  if (inquiry.subject != null && inquiry.subject!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        inquiry.subject!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ),
                  Text(inquiry.message ?? ''),
                  const SizedBox(height: 12),
                  Text(
                    dateStr.isNotEmpty ? dateStr : inquiry.createdAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Single inquiry card: sender, date, type, subject, message preview
class _InquiryCard extends StatelessWidget {
  final InquiryModel inquiry;
  final bool isDark;
  final VoidCallback onTap;

  const _InquiryCard({
    required this.inquiry,
    required this.isDark,
    required this.onTap,
  });

  static String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final d = DateTime.tryParse(dateStr);
      if (d == null) return dateStr;
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final mutedColor = isDark ? AppColors.mutedDark : AppColors.mutedLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final String messagePreview = inquiry.message != null && inquiry.message!.isNotEmpty
        ? (inquiry.message!.length > 80 ? '${inquiry.message!.substring(0, 80)}...' : inquiry.message!)
        : '';

    final subjectLine = inquiry.subject != null && inquiry.subject!.trim().isNotEmpty
        ? inquiry.subject!.trim()
        : (inquiry.vehicleTitle != null && inquiry.vehicleTitle!.trim().isNotEmpty
            ? 'Inquiry for ${inquiry.vehicleTitle!.trim()}'
            : 'Inquiry');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inquiry.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          inquiry.displayEmail,
                          style: TextStyle(
                            fontSize: 13,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDate(inquiry.createdAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          inquiry.displayType,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                subjectLine,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (messagePreview.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  messagePreview,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

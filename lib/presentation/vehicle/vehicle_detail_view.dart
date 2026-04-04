import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/vehicle_detail_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../main.dart';
import '../../models/vehicle_detail_model/vehicle_detail_model.dart';
import '../../repositories/vehicle/vehicle_repository.dart';
import '../widgets/detail_section_card.dart';
import '../widgets/expandable_section_card.dart';
import '../widgets/vehicle_detail_shimmer.dart';
import 'vehicle_detail_helpers.dart';
import 'widgets/enquiry_form_bottom_sheet.dart';

class VehicleDetailView extends StatefulWidget {
  const VehicleDetailView({super.key});

  @override
  State<VehicleDetailView> createState() => _VehicleDetailViewState();
}

class _VehicleDetailViewState extends State<VehicleDetailView> {
  late FavoriteController _favoriteController;
  bool _isLoggedIn = false;
  bool _hasCheckedFavorite = false;

  static bool _isOwnListing(VehicleDetailModel vehicle) {
    if (vehicle.userId == null) return false;
    try {
      final userJson = appStorage.read('user');
      if (userJson == null) return false;
      final userMap = jsonDecode(userJson.toString()) as Map<String, dynamic>;
      final currentId = userMap['id'];
      if (currentId == null) return false;
      final currentIdInt =
          currentId is int ? currentId : (currentId is num ? currentId.toInt() : null);
      return currentIdInt != null && vehicle.userId == currentIdInt;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _favoriteController = Get.put(FavoriteController());
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final token = appStorage.read('token');
    setState(() {
      _isLoggedIn = token != null && token.toString().isNotEmpty;
    });
  }

  void _maybeCheckFavoriteStatus(VehicleDetailModel vehicle) {
    if (!_isLoggedIn || _hasCheckedFavorite) return;
    _favoriteController.checkFavoriteStatus(vehicle.id);
    _hasCheckedFavorite = true;
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

  void _handleFavoriteToggle(BuildContext context, VehicleDetailModel vehicle) {
    if (!_isLoggedIn) {
      _showLoginRequiredDialog(context);
      return;
    }
    _favoriteController.toggleFavorite(vehicle.id);
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final controller = Get.put(VehicleDetailController());
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FB);

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0A4AA8),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : const Color(0xFF0A4AA8),
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) return VehicleDetailShimmer(isDark: isDark);
          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState(context, controller, isDark, l10n);
          }

          final vehicle = controller.vehicleDetail.value;
          if (vehicle == null) return Center(child: Text(l10n.noVehicleDataAvailable));

          final own = _isOwnListing(vehicle);
          _maybeCheckFavoriteStatus(vehicle);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeroCard(context, vehicle, isDark, own),
                  const SizedBox(height: 14),
                  _buildTitleBlock(context, vehicle, isDark, l10n),
                  const SizedBox(height: 14),
                  _buildPriceAndActionsCard(context, vehicle, isDark, l10n, own),
                  const SizedBox(height: 14),
                  _buildQuickFactsGrid(context, vehicle, isDark, l10n),
                  const SizedBox(height: 14),
                  _buildVehicleSpecifications(context, vehicle, isDark, l10n),
                  const SizedBox(height: 14),
                  if (hasConditionHistorySection(vehicle))
                    _buildConditionHistoryModern(context, vehicle, isDark, l10n),
                  if (hasConditionHistorySection(vehicle)) const SizedBox(height: 14),
                  _buildTechnicalSpecsModern(context, vehicle, isDark, l10n),
                  
                  if (!own) ...[
                    const SizedBox(height: 14),
                    _buildSellerCardModern(context, vehicle, isDark, l10n),
                  ],
                  const SizedBox(height: 14),
                  _buildAdditionalSections(context, vehicle, isDark, l10n, own),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildErrorState(BuildContext context, VehicleDetailController controller,
      bool isDark, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final vehicleId = Get.parameters['id'];
                if (vehicleId != null) {
                  controller.fetchVehicleDetail(int.parse(vehicleId));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    VehicleDetailModel v,
    bool isDark,
    bool ownListing,
  ) {
    return _HeroGalleryCard(
      images: v.images,
      isDark: isDark,
      vehicleId: v.id,
      isOwnListing: ownListing,
      isLoggedIn: _isLoggedIn,
      favoriteController: _favoriteController,
      onFavoriteToggle: () => _handleFavoriteToggle(context, v),
    );
  }

  Widget _buildTitleBlock(
      BuildContext context, VehicleDetailModel v, bool isDark, AppLocalizations l10n) {
    final subtitle = [
      if (v.engineDisplacementLitres != null)
        '${intl.NumberFormat('#0.0', 'da_DK').format(v.engineDisplacementLitres)} ${v.engineType ?? 'GLS'}',
      if (v.bodyTypeName != null && v.bodyTypeName!.isNotEmpty) v.bodyTypeName!,
      if (v.effectiveModelYearLabel != null) v.effectiveModelYearLabel!,
    ].join('   ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF172033) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFE5EAF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (v.listingTypeName != null && v.listingTypeName!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0A4AA8).withOpacity(0.2) : const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                v.listingTypeName!.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: isDark ? const Color(0xFF8FB7FF) : const Color(0xFF0A4AA8),
                ),
              ),
            ),
          Text(
            v.title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF12233D),
              height: 1.1,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF93A4BE) : const Color(0xFF6D7A8D),
              ),
            ),
          ],
          if (v.salesTypeName != null && v.salesTypeName!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              v.salesTypeName!,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFFB1C0D7) : const Color(0xFF657489),
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildQuickFactsGrid(
      BuildContext context, VehicleDetailModel v, bool isDark, AppLocalizations l10n) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.65,
      children: [
        _factTile(
          isDark: isDark,
          icon: Icons.route_rounded,
          label: l10n.kilometersDriven,
          value: v.kmDriven != null ? formatMileage(v.kmDriven) : '—',
        ),
        _factTile(
          isDark: isDark,
          icon: Icons.event_rounded,
          label: l10n.firstRegistration,
          value: v.firstRegistrationDate != null
              ? formatDate(context, v.firstRegistrationDate)
              : '—',
        ),
        if (v.fuelTypeName != null && v.fuelTypeName!.isNotEmpty) ...[
          _factTile(
            isDark: isDark,
            icon: Icons.local_gas_station_rounded,
            label: l10n.fuelType,
            value: v.fuelTypeName ?? '—',
          ),
        ],
        _factTile(
          isDark: isDark,
          icon: Icons.settings_rounded,
          label: l10n.transmission,
          value: v.gearTypeName ?? '—',
        ),
      ],
    );
  }

  Widget _factTile({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF172033) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFE5EAF3)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A4AA8).withOpacity(0.25) : const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF0A4AA8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF90A1BC) : const Color(0xFF778399),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.2,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF132746),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildConditionHistoryModern(
      BuildContext context, VehicleDetailModel v, bool isDark, AppLocalizations l10n) {
    final rows = <({String label, String value, bool multiline})>[];

    void addPlain(String label, String? raw) {
      if (raw == null) return;
      final s = raw.trim();
      if (s.isEmpty) return;
      rows.add((label: label, value: s, multiline: false));
    }

    final desc = v.description?.trim();
    if (desc != null && desc.isNotEmpty) {
      rows.add((label: l10n.description, value: desc, multiline: true));
    }
    addPlain(l10n.type, v.categoryName);
    addPlain(l10n.use, v.useName);
    addPlain(l10n.priceType, v.priceTypeName);
    addPlain(l10n.condition, v.conditionName);
    final sb = v.servicebog?.trim();
    if (sb != null && sb.isNotEmpty && sb != 'Default') {
      rows.add((label: l10n.serviceBook, value: sb, multiline: false));
    }

    return _sectionCard(
      isDark: isDark,
      title: l10n.conditionAndHistory,
      child: rows.isEmpty ? const SizedBox.shrink() : _buildSpecRowsCore(rows, isDark),
    );
  }

  Widget _buildTechnicalSpecsModern(
      BuildContext context, VehicleDetailModel v, bool isDark, AppLocalizations l10n) {
    final rows = <({String label, String value, bool multiline})>[];
    final nfInt = intl.NumberFormat('#,##0', 'da_DK');
    final nfDec2 = intl.NumberFormat('#0.00', 'da_DK');

    void addPlain(String label, String? raw) {
      if (raw == null) return;
      final s = raw.trim();
      if (s.isEmpty) return;
      rows.add((label: label, value: s, multiline: false));
    }

    addPlain(l10n.color, v.colourName);
    addPlain(l10n.bodyType, v.bodyTypeName);
    addPlain(l10n.variant, v.variantName);
    addPlain(l10n.gearType, v.gearTypeName);
    addPlain(l10n.engineTypeLabel, v.engineType);

    if (v.engineDisplacementLitres != null) {
      rows.add((
        label: l10n.engineDisplacementLitres,
        value: '${nfDec2.format(v.engineDisplacementLitres)} L',
        multiline: false,
      ));
    }

    if (v.gearCount != null) {
      rows.add((label: l10n.gearCount, value: '${v.gearCount}', multiline: false));
    }

    final ttw = v.technicalTotalWeightKg;
    if (ttw != null && ttw != 0) {
      rows.add((
        label: l10n.technicalTotalWeight,
        value: '${nfInt.format(ttw.round())} kg',
        multiline: false,
      ));
    }

    if (v.engineSizeCc != null && v.engineSizeCc != 0) {
      rows.add((
        label: l10n.engineDisplacementCc,
        value: '${nfInt.format(v.engineSizeCc)} cc',
        multiline: false,
      ));
    }

    if (v.doorCount != null) {
      rows.add((label: l10n.doorsMin, value: '${v.doorCount}', multiline: false));
    }

    if (v.seatsMin != null || v.seatsMax != null) {
      rows.add((
        label: '${l10n.minimumSeats} / ${l10n.maximumSeats}',
        value: '${v.seatsMin ?? ''} — ${v.seatsMax ?? ''}',
        multiline: false,
      ));
    }

    if (v.maxSpeed != null) {
      rows.add((
        label: l10n.topSpeedKmh,
        value: '${nfInt.format(v.maxSpeed!.round())} km/h',
        multiline: false,
      ));
    }

    final eff = kmEfficiencyDisplay(l10n, v);
    if (eff != null) {
      rows.add((label: eff.label, value: eff.value, multiline: false));
    }

    addPlain(l10n.euroNorm, v.emissionNormName);

    if (v.axleCount != null) {
      rows.add((label: l10n.axles, value: '${v.axleCount}', multiline: false));
    }

    final extra = v.dmr?.extraEquipment?.trim();
    if (extra != null && extra.isNotEmpty) {
      rows.add((label: l10n.extraEquipment, value: extra, multiline: true));
    }

    for (final s in v.specifications.where((x) => x.count > 1)) {
      rows.add((label: s.name, value: '${s.count}', multiline: false));
    }

    for (final d in v.specDefinitions) {
      if (d.name.trim().isEmpty) continue;
      final val = d.value?.trim() ?? '';
      rows.add((label: d.name, value: val, multiline: true));
    }

    return _sectionCard(
      isDark: isDark,
      title: l10n.technicalSpecifications,
      child: rows.isEmpty ? const SizedBox.shrink() : _buildSpecRowsCore(rows, isDark),
    );
  }

  Widget _buildSpecRows(List<MapEntry<String, String>> rows, bool isDark) {
    return _buildSpecRowsCore(
      rows
          .map((e) => (label: e.key, value: e.value, multiline: false))
          .toList(),
      isDark,
    );
  }

  Widget _buildSpecRowsCore(List<({String label, String value, bool multiline})> rows, bool isDark) {
    final labelStyle = TextStyle(
      color: isDark ? const Color(0xFF97AACC) : const Color(0xFF6C7A90),
      fontWeight: FontWeight.w600,
      fontSize: 13.2,
    );
    final valueStyle = TextStyle(
      color: isDark ? Colors.white : const Color(0xFF12243D),
      fontWeight: FontWeight.w700,
      fontSize: 13.4,
    );

    return Column(
      children: rows
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: r.multiline
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.label, style: labelStyle),
                        const SizedBox(height: 4),
                        Text(
                          r.value,
                          style: valueStyle,
                          softWrap: true,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(r.label, style: labelStyle)),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            r.value,
                            textAlign: TextAlign.right,
                            style: valueStyle,
                          ),
                        ),
                      ],
                    ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPriceAndActionsCard(BuildContext context, VehicleDetailModel v, bool isDark,
      AppLocalizations l10n, bool ownListing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF172033) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFE5EAF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pricing.toUpperCase(),
            style: TextStyle(
              letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: isDark ? const Color(0xFF8EA1C1) : const Color(0xFF7A879B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatPriceKr(v.price),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFF9CC0FF) : const Color(0xFF0A4AA8),
              height: 1.06,
            ),
          ),
          if (!ownListing) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openEnquiryForm(context, v, EnquiryFormType.enquiry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A4AA8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(l10n.sendEnquiry),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _openEnquiryForm(context, v, EnquiryFormType.testDrive),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0A4AA8),
                  side: BorderSide(color: const Color(0xFF0A4AA8).withOpacity(0.35)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l10n.requestTestDrive),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _smallActionButton(
                    label: l10n.exchangeRequest,
                    onTap: () => _openEnquiryForm(context, v, EnquiryFormType.exchange),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _smallActionButton(
                    label: l10n.priceNegotiation,
                    onTap: () =>
                        _openEnquiryForm(context, v, EnquiryFormType.priceNegotiation),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _smallActionButton({
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF223250) : const Color(0xFFF2F6FD),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDark ? const Color(0xFFD5E5FF) : const Color(0xFF2A405F),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSellerCardModern(
      BuildContext context, VehicleDetailModel v, bool isDark, AppLocalizations l10n) {
    final dealer = v.dealer;
    final user = v.user;
    final name = dealer?.owner?.name ?? user?.name ?? l10n.seller;
    final phone = dealer?.owner?.phone ?? user?.phone;
    final email = dealer?.owner?.email ?? user?.email;
    final subtitle = dealer != null ? l10n.dealerInformation : l10n.sellerInformation;

    return _sectionCard(
      isDark: isDark,
      title: l10n.sellerInformation,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isDark ? const Color(0xFF223250) : const Color(0xFFEAF1FF),
                ),
                child: Icon(Icons.person, color: const Color(0xFF0A4AA8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF12243D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? const Color(0xFF99AACA) : const Color(0xFF6D7A8F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (phone != null && phone.isNotEmpty)
            _contactRow(
              icon: Icons.phone_rounded,
              label: phone,
              isDark: isDark,
              onTap: () => _launchPhoneDirect(context, phone, v.id),
            ),
          if (email != null && email.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _contactRow(
              icon: Icons.email_rounded,
              label: email.trim(),
              isDark: isDark,
              onTap: () => _launchEmailTo(context, email.trim(), v.title, v.id),
            ),
          ],
        ],
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF223250) : const Color(0xFFF4F8FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF0A4AA8)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? const Color(0xFFE4EDFF) : const Color(0xFF1A3556),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required bool isDark,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF172033) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFE5EAF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF12304F),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  BoxDecoration _expandableSectionDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF172033) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark ? Colors.white12 : const Color(0xFFE5EAF3),
      ),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black.withOpacity(0.22) : Colors.black.withOpacity(0.05),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildAdditionalSections(BuildContext context, VehicleDetailModel v, bool isDark,
      AppLocalizations l10n, bool own) {
    const sectionGapHeight = 12.0;
    final sections = <Widget>[
      _buildRegistrationSection(context, v, isDark, l10n),
      if (v.lastInspectionDate != null) _buildInspectionSection(context, v, isDark, l10n),
      if (hasLeasingSection(v)) _buildLeasingSection(context, v, isDark, l10n),
      if (v.equipment.isNotEmpty) _buildEquipmentSection(context, v, isDark, l10n),
      if ((v.publishedAt ?? v.createdAt)?.isNotEmpty == true)
        _buildListingInfo(context, v, isDark, l10n),
      if (!own) _buildInterestedSection(context, isDark, v, l10n),
    ];

    final spacedSections = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      spacedSections.add(sections[i]);
      if (i < sections.length - 1) {
        spacedSections.add(const SizedBox(height: sectionGapHeight));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: spacedSections,
    );
  }

  Widget _buildVehicleSpecifications(BuildContext context, VehicleDetailModel v,
      bool isDark, AppLocalizations l10n) {
    final specs = <MapEntry<String, String>>[];
    void add(String label, dynamic value) {
      if (value == null) return;
      final s = value.toString().trim();
      if (s.isEmpty) return;
      specs.add(MapEntry(label, s));
    }

    final nfInt = intl.NumberFormat('#,##0', 'da_DK');
    final nf0 = intl.NumberFormat('#0', 'da_DK');
    final nf2 = intl.NumberFormat('#0.00', 'da_DK');
    final nf3 = intl.NumberFormat('#0.000', 'da_DK');
    final consumptionSuffix = l10n.consumptionLPer100kmSuffix;

    add(l10n.brand, v.brandName);
    add(l10n.model, v.modelName);
    add(l10n.modelYear, v.modelYearDisplay?.trim());
    add(l10n.fuelType, v.fuelTypeName);
    if (v.enginePowerHp != null && v.enginePowerHp! > 0) {
      add(l10n.enginePower, '${nf0.format(v.enginePowerHp)} HP');
    }
    if (v.kmDriven != null && v.kmDriven != 0) {
      add(l10n.kilometersDriven, formatMileage(v.kmDriven));
    }
    if (v.batteryCapacity != null && v.batteryCapacity!.isNotEmpty) {
      add(l10n.batteryCapacityKwh, '${v.batteryCapacity} kWh');
    }
    if (v.rangeKm != null && v.rangeKm != 0) {
      add(l10n.rangeKm, '${nfInt.format(v.rangeKm)} km');
    }
    add(l10n.chargingType, v.chargingType);
    if (v.towingWeight != null && v.towingWeight! > 0) {
      add(l10n.towingWeightKg, '${nfInt.format(v.towingWeight!.round())} kg');
    }
    final ownership = v.calculatedOwnershipTax;
    if (ownership != null && ownership != 0) {
      add(l10n.ownerTax, formatCurrencyDkk(ownership));
    }
    if (v.annualTax != null && v.annualTax!.trim().isNotEmpty) {
      final annualParsed = parseAnnualTaxAmount(v.annualTax);
      if (annualParsed != null) {
        add(l10n.annualTax, formatCurrencyDkk(annualParsed));
      } else {
        add(l10n.annualTax, v.annualTax!.trim());
      }
    }
    if (v.firstRegistrationDate != null && v.firstRegistrationDate!.trim().isNotEmpty) {
      final d = formatDate(context, v.firstRegistrationDate);
      if (d.isNotEmpty) add(l10n.firstRegistration, d);
    }
    if (v.firstRegistrationYear != null && v.firstRegistrationYear! > 0) {
      add(l10n.firstRegistrationYear, '${v.firstRegistrationYear}');
    }
    if (v.productionDate != null && v.productionDate!.trim().isNotEmpty) {
      final d = formatDate(context, v.productionDate);
      if (d.isNotEmpty) add(l10n.productionDate, d);
    }
    if (v.co2Emission != null) {
      add(l10n.co2Emission, '${nf0.format(v.co2Emission)} g/km');
    }
    if (v.electricalConsumption != null) {
      add(
        l10n.electricalConsumption,
        '${nf2.format(v.electricalConsumption)} kWh/100km',
      );
    }
    if (v.noxEmission != null) {
      add(l10n.noxEmission, nf3.format(v.noxEmission));
    }
    if (v.fuelConsumptionWltp != null) {
      add(
        l10n.fuelConsumptionWltp,
        '${nf2.format(v.fuelConsumptionWltp)} $consumptionSuffix',
      );
    }
    if (v.fuelConsumptionNedc != null) {
      add(
        l10n.fuelConsumptionNedc,
        '${nf2.format(v.fuelConsumptionNedc)} $consumptionSuffix',
      );
    }
    add(l10n.measurementNorm, v.measurementNormName);
    if (v.enginePowerKw != null) {
      add(
        l10n.enginePowerKw,
        '${intl.NumberFormat('#0.0', 'da_DK').format(v.enginePowerKw)} kW',
      );
    }

    return _sectionCard(
      isDark: isDark,
      title: l10n.vehicleSpecifications,
      child: specs.isEmpty ? const SizedBox.shrink() : _buildSpecRows(specs, isDark),
    );
  }

  Widget _buildRegistrationSection(BuildContext context, VehicleDetailModel v,
      bool isDark, AppLocalizations l10n) {
    final specs = <MapEntry<String, String>>[];
    if (v.registrationStatus != null && v.registrationStatus!.isNotEmpty) {
      specs.add(MapEntry(l10n.registrationStatus, v.registrationStatus!));
    }
    final dmrName = v.dmr?.registrationStatusName;
    if (dmrName != null && dmrName.isNotEmpty) {
      specs.add(MapEntry(l10n.registrationStatusDmr, dmrName));
    }
    if (v.lastRegistrationChange != null) {
      specs.add(
        MapEntry(
          l10n.lastRegistrationChange,
          formatDate(context, v.lastRegistrationChange),
        ),
      );
    }
    if (specs.isEmpty) return const SizedBox.shrink();
    return _sectionCard(
      isDark: isDark,
      title: l10n.registrationAndStatus,
      child: _buildSpecRows(specs, isDark),
    );
  }

  Widget _buildInspectionSection(BuildContext context, VehicleDetailModel v,
      bool isDark, AppLocalizations l10n) {
    if (v.lastInspectionDate == null) return const SizedBox.shrink();
    return DetailSectionCard(
      title: l10n.inspectionDetails,
      isDark: isDark,
      initiallyExpanded: false,
      items: [
        DetailItem(
          label: l10n.lastInspectionDate,
          value: formatDate(context, v.lastInspectionDate),
        ),
      ],
    );
  }

  Widget _buildLeasingSection(BuildContext context, VehicleDetailModel v, bool isDark,
      AppLocalizations l10n) {
    final specs = <MapEntry<String, String>>[];
    void add(String label, dynamic value) {
      if (value == null) return;
      final s = value.toString().trim();
      if (s.isEmpty) return;
      specs.add(MapEntry(label, s));
    }

    add(l10n.leasingType, v.leasingType);
    add(l10n.leasingCustomerType, v.leasingCustomerType);
    if (v.leasingMonthlyPayment != null) {
      add(l10n.leasingMonthlyPayment, formatKrDouble(v.leasingMonthlyPayment));
    }
    if (v.leasingFirstPayment != null) {
      add(l10n.leasingFirstPayment, formatKrDouble(v.leasingFirstPayment));
    }
    if (v.leasingResidualValue != null) {
      add(l10n.leasingResidualValue, formatKrDouble(v.leasingResidualValue));
    }
    if (v.leasingDuration != null) add(l10n.leasingDuration, '${v.leasingDuration}');
    if (v.leasingAnnualMileage != null) {
      add(l10n.leasingAnnualMileage, formatMileage(v.leasingAnnualMileage));
    }
    if (v.leasingTotalCost != null) {
      add(l10n.leasingTotalCost, formatKrDouble(v.leasingTotalCost));
    }
    if (specs.isEmpty) return const SizedBox.shrink();
    return ExpandableSectionCard(
      title: l10n.leasingInformation,
      icon: Icons.account_balance_wallet_outlined,
      isDark: isDark,
      initiallyExpanded: false,
      margin: EdgeInsets.zero,
      decoration: _expandableSectionDecoration(isDark),
      child: _buildSpecRows(specs, isDark),
    );
  }

  Widget _buildEquipmentSection(BuildContext context, VehicleDetailModel v,
      bool isDark, AppLocalizations l10n) {
    return ExpandableSectionCard(
      title: l10n.equipmentAndFeatures,
      icon: Icons.checklist_outlined,
      isDark: isDark,
      initiallyExpanded: false,
      margin: EdgeInsets.zero,
      decoration: _expandableSectionDecoration(isDark),
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: v.equipment
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.08) : AppColors.mutedBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline, size: 15, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(
                      e.name,
                      style: TextStyle(
                        fontSize: 13.2,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildListingInfo(BuildContext context, VehicleDetailModel v, bool isDark,
      AppLocalizations l10n) {
    final dateStr = v.publishedAt ?? v.createdAt;
    if (dateStr == null || dateStr.isEmpty) return const SizedBox.shrink();
    return ExpandableSectionCard(
      title: l10n.listingInformation,
      icon: Icons.info_outline,
      isDark: isDark,
      initiallyExpanded: false,
      margin: EdgeInsets.zero,
      decoration: _expandableSectionDecoration(isDark),
      child: _buildSpecRows(
        [
          MapEntry(l10n.addedToListing, formatDaysAgo(context, dateStr, l10n)),
        ],
        isDark,
      ),
    );
  }

  Widget _buildInterestedSection(
      BuildContext context, bool isDark, VehicleDetailModel vehicle, AppLocalizations l10n) {
    return ExpandableSectionCard(
      title: l10n.interestedTitle,
      icon: Icons.favorite_outline,
      isDark: isDark,
      initiallyExpanded: false,
      margin: EdgeInsets.zero,
      decoration: _expandableSectionDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.takeNextSteps,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF97AACC) : const Color(0xFF6C7A90),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _modernInterestedItem(
            icon: Icons.history,
            text: l10n.requestVehicleHistory,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _modernInterestedItem(
            icon: Icons.check_circle_outline,
            text: l10n.scheduleInspection,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _modernInterestedItem(
            icon: Icons.account_balance_wallet_outlined,
            text: l10n.discussFinancing,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _modernInterestedItem(
            icon: Icons.directions_car_outlined,
            text: l10n.arrangeTestDrive,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _modernInterestedItem({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF223250) : const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0A4AA8)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.8,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFE4EDFF) : const Color(0xFF1A3556),
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: isDark ? const Color(0xFF9EB2D2) : const Color(0xFF7F8FA8),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhoneDirect(BuildContext context, String phone, int vehicleId) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.parse('tel:$phone');
    try {
      try {
        await VehicleRepository().createLead(vehicleId, 'phone_shown');
      } catch (_) {}
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        Get.snackbar(l10n.error, l10n.couldNotOpenPhoneDialer);
      }
    } catch (_) {
      Get.snackbar(l10n.error, l10n.couldNotOpenPhoneDialer);
    }
  }

  Future<void> _launchEmailTo(
    BuildContext context,
    String email,
    String title,
    int vehicleId,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await VehicleRepository().createLead(vehicleId, 'email_clicked');
    } catch (_) {}
    final subject = Uri.encodeComponent('Enquiry about: $title');
    final body = Uri.encodeComponent(
      'Hello,\n\nI am interested in this vehicle: $title\n\nPlease contact me with more information.\n\nThank you!',
    );
    final uri = Uri.parse('mailto:${email.trim()}?subject=$subject&body=$body');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar(l10n.sendEmail, l10n.couldNotOpenEmailApp, snackPosition: SnackPosition.TOP);
      }
    } catch (_) {
      Get.snackbar(l10n.sendEmail, l10n.couldNotOpenEmailApp, snackPosition: SnackPosition.TOP);
    }
  }

  // ignore: unused_element
  void _showContactActionsBottomSheet(
      BuildContext context, VehicleDetailModel vehicle, bool isDark) {
    final hasContact = vehicle.user != null || vehicle.dealer != null;
    if (!hasContact) return;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Text(
                  AppLocalizations.of(context)!.contactSeller,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.chat_bubble_outline,
                      label: AppLocalizations.of(context)!.sendEnquiry,
                      onTap: () => _openEnquiryForm(context, vehicle, EnquiryFormType.enquiry),
                    ),
                    const SizedBox(height: 12),
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.swap_horiz,
                      label: AppLocalizations.of(context)!.exchangeRequest,
                      onTap: () => _openEnquiryForm(context, vehicle, EnquiryFormType.exchange),
                    ),
                    const SizedBox(height: 12),
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.directions_car_outlined,
                      label: AppLocalizations.of(context)!.requestTestDrive,
                      onTap: () => _openEnquiryForm(context, vehicle, EnquiryFormType.testDrive),
                    ),
                    const SizedBox(height: 12),
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.attach_money,
                      label: AppLocalizations.of(context)!.priceNegotiation,
                      onTap: () =>
                          _openEnquiryForm(context, vehicle, EnquiryFormType.priceNegotiation),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _openEnquiryForm(
    BuildContext context,
    VehicleDetailModel vehicle,
    EnquiryFormType type,
  ) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    Get.bottomSheet(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: EnquiryFormBottomSheet(
          vehicleId: vehicle.id,
          vehicleTitle: vehicle.title,
          type: type,
          brandName: vehicle.brandName,
          modelName: vehicle.modelName,
          price: vehicle.price,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildContactSheetTile({
    required BuildContext context,
    required VehicleDetailModel vehicle,
    required bool isDark,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroGalleryCard extends StatefulWidget {
  final List<VehicleImage> images;
  final bool isDark;
  final int vehicleId;
  final bool isOwnListing;
  final bool isLoggedIn;
  final FavoriteController favoriteController;
  final VoidCallback onFavoriteToggle;

  const _HeroGalleryCard({
    required this.images,
    required this.isDark,
    required this.vehicleId,
    required this.isOwnListing,
    required this.isLoggedIn,
    required this.favoriteController,
    required this.onFavoriteToggle,
  });

  @override
  State<_HeroGalleryCard> createState() => _HeroGalleryCardState();
}

class _HeroGalleryCardState extends State<_HeroGalleryCard> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (index < 0 || index >= widget.images.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _openPreview(int initialIndex) {
    if (widget.images.isEmpty) return;
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (_, __, ___) => _HeroImagePreview(
          images: widget.images,
          initialIndex: initialIndex,
          isDark: widget.isDark,
        ),
      ),
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      color: widget.isDark ? const Color(0xFF1E293B) : const Color(0xFFD9E2EE),
      alignment: Alignment.center,
      child: Icon(
        Icons.directions_car_filled_rounded,
        size: 64,
        color: widget.isDark ? Colors.white24 : Colors.white70,
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.32),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.24)),
        ),
        child: Icon(icon, color: Colors.white, size: 19),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;
    final total = widget.images.length;
    final hasMultiple = total > 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
          border: Border.all(
            color: widget.isDark ? Colors.white12 : const Color(0xFFE4E9F2),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!hasImages)
              _heroPlaceholder()
            else
              PageView.builder(
                controller: _pageController,
                physics: const PageScrollPhysics(),
                itemCount: total,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => _openPreview(index),
                    child: Image.network(
                      widget.images[index].imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _heroPlaceholder(),
                    ),
                  );
                },
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (hasMultiple && _currentIndex > 0)
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _navButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _goToPage(_currentIndex - 1),
                  ),
                ),
              ),
            if (hasMultiple && _currentIndex < total - 1)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _navButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _goToPage(_currentIndex + 1),
                  ),
                ),
              ),
            if (widget.isLoggedIn && !widget.isOwnListing)
              Positioned(
                top: 16,
                right: 16,
                child: Obx(() {
                  final isFavorite =
                      widget.favoriteController.isFavorite(widget.vehicleId);
                  final isLoading =
                      widget.favoriteController.isLoading(widget.vehicleId);
                  return Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(widget.isDark ? 0.95 : 0.98),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black87,
                              size: 20,
                            ),
                      onPressed: isLoading ? null : widget.onFavoriteToggle,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  );
                }),
              ),
            if (hasMultiple)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    total,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: index == _currentIndex ? 18 : 6,
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? Colors.white
                            : Colors.white.withOpacity(0.48),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroImagePreview extends StatefulWidget {
  final List<VehicleImage> images;
  final int initialIndex;
  final bool isDark;

  const _HeroImagePreview({
    required this.images,
    required this.initialIndex,
    required this.isDark,
  });

  @override
  State<_HeroImagePreview> createState() => _HeroImagePreviewState();
}

class _HeroImagePreviewState extends State<_HeroImagePreview> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.images.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _fallback() {
    return Container(
      color: widget.isDark ? const Color(0xFF0B1220) : const Color(0xFF1F2937),
      alignment: Alignment.center,
      child: const Icon(
        Icons.directions_car_filled_rounded,
        size: 70,
        color: Colors.white30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.94),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (value) {
                setState(() {
                  _index = value;
                });
              },
              itemBuilder: (_, i) {
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Image.network(
                      widget.images[i].imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => _fallback(),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 12,
              left: 10,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  '${_index + 1} / ${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

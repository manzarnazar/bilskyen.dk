import 'dart:convert';

import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:bilskyen/gen_l10n/app_localizations.dart';

import '../../../utils/app_colors.dart';
import '../../../controllers/app_controller/app_controller.dart';
import '../../../repositories/vehicle/vehicle_repository.dart';

enum EnquiryFormType { enquiry, testDrive, priceNegotiation, exchange }

/// Reusable enquiry form content used by both bottom sheets and full screens.
class EnquiryFormContent extends StatefulWidget {
  final int vehicleId;
  final String vehicleTitle;
  final EnquiryFormType type;
  final String? brandName;
  final String? modelName;
  final int? price;

  const EnquiryFormContent({
    super.key,
    required this.vehicleId,
    required this.vehicleTitle,
    required this.type,
    this.brandName,
    this.modelName,
    this.price,
  });

  @override
  State<EnquiryFormContent> createState() => _EnquiryFormContentState();
}

class _EnquiryFormContentState extends State<EnquiryFormContent> {
  final VehicleRepository _repository = VehicleRepository();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _licencePlateController = TextEditingController();
  final _kilometersController = TextEditingController();
  final _expectedPriceController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _prefillFromUser();
  }

  void _prefillFromUser() {
    final userJson = GetStorage().read('user');
    if (userJson != null) {
      try {
        final userMap =
            jsonDecode(userJson.toString()) as Map<String, dynamic>;
        final name = userMap['name'] as String?;
        final email = userMap['email'] as String?;
        if (name != null && name.isNotEmpty) _nameController.text = name;
        if (email != null && email.isNotEmpty) _emailController.text = email;
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _licencePlateController.dispose();
    _kilometersController.dispose();
    _expectedPriceController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final priceStr = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) buffer.write(',');
      buffer.write(priceStr[i]);
    }
    return '${buffer.toString()} kr.';
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone =
        _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim();
    final message = _messageController.text.trim();
    final licencePlate = _licencePlateController.text.trim();
    final kilometersText = _kilometersController.text.trim();
    final expectedPrice = _expectedPriceController.text.trim();

    late Either<String, Map<String, dynamic>> result;
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        result = await _repository.submitEnquiry(
          widget.vehicleId,
          name: name,
          email: email,
          phone: phone,
          message: message,
        );
        break;
      case EnquiryFormType.testDrive:
        result = await _repository.submitTestDrive(
          widget.vehicleId,
          name: name,
          email: email,
          phone: phone,
          message: message,
        );
        break;
      case EnquiryFormType.priceNegotiation:
        result = await _repository.submitPriceNegotiation(
          widget.vehicleId,
          name: name,
          email: email,
          phone: phone,
          message: message,
        );
        break;
      case EnquiryFormType.exchange:
        result = await _repository.submitExchange(
          widget.vehicleId,
          name: name,
          email: email,
          phone: phone,
          message: message,
          licencePlate: licencePlate,
          kilometers: kilometersText,
          expectedPrice: expectedPrice,
        );
        break;
    }

    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        Get.snackbar(l10n.error, error, snackPosition: SnackPosition.TOP);
      },
      (_) {
        Get.back();
        final successMsg = switch (widget.type) {
          EnquiryFormType.enquiry => l10n.enquirySuccessMessage,
          EnquiryFormType.exchange => l10n.exchangeSuccessMessage,
          EnquiryFormType.testDrive => l10n.testDriveSuccessMessage,
          EnquiryFormType.priceNegotiation => l10n.priceNegotiationSuccessMessage,
        };
        Get.snackbar(
          l10n.success,
          successMsg,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, isDark, l10n),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _description(l10n),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildVehicleInfo(context, isDark, l10n),
                    const SizedBox(height: 24),
                    Text(
                      widget.type == EnquiryFormType.priceNegotiation
                          ? l10n.yourOffer
                          : l10n.yourDetails,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nameController,
                      label: '${l10n.fullNameLabel} *',
                      hint: l10n.enterFullNamePlaceholder,
                      isDark: isDark,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.nameRequired
                          : null,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: '${l10n.emailLabel} *',
                      hint: l10n.enterEmailPlaceholder,
                      isDark: isDark,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.emailRequired;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: l10n.phoneNumber,
                      hint: l10n.enterPhoneOptionalPlaceholder,
                      isDark: isDark,
                      validator: null,
                      keyboardType: TextInputType.phone,
                    ),
                    if (widget.type == EnquiryFormType.exchange) ...[
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _licencePlateController,
                        label: 'Licence plate *',
                        hint: 'Enter licence plate',
                        isDark: isDark,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Licence plate is required'
                            : null,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _kilometersController,
                        label: 'Kilometres used *',
                        hint: 'Enter kilometres used',
                        isDark: isDark,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Kilometres used is required';
                          }
                          final value = int.tryParse(v.trim());
                          if (value == null || value < 0) {
                            return 'Enter a valid non-negative number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _expectedPriceController,
                        label: 'Expected price *',
                        hint: 'Enter your expected price',
                        isDark: isDark,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Expected price is required'
                            : null,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildMessageField(context, isDark, l10n),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                _isSubmitting ? null : () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(l10n.cancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.primaryForeground,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _submitText(l10n),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(l10n),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark
                  ? AppColors.mutedDark
                  : AppColors.mutedLight,
            ),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final priceFormatted =
        widget.price != null ? _formatPrice(widget.price!) : null;
    final priceLabel = widget.type == EnquiryFormType.priceNegotiation
        ? l10n.currentPrice
        : l10n.priceLabel;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.mutedBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vehicleInformation,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(
                      l10n.vehicleLabel,
                      widget.vehicleTitle,
                      isDark,
                      false,
                    ),
                    if (widget.brandName != null &&
                        widget.brandName!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _infoRow(
                        l10n.brand,
                        widget.brandName!,
                        isDark,
                        false,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(
                      priceLabel,
                      priceFormatted ?? '—',
                      isDark,
                      priceFormatted != null,
                    ),
                    if (widget.modelName != null &&
                        widget.modelName!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _infoRow(
                        l10n.model,
                        widget.modelName!,
                        isDark,
                        false,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
    bool isDark,
    bool highlight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: highlight
                ? AppColors.primary
                : (isDark ? AppColors.textDark : AppColors.textLight),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    required String? Function(String?)? validator,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: isDark ? AppColors.backgroundDark : AppColors.mutedBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildMessageField(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final label = widget.type == EnquiryFormType.priceNegotiation
        ? '${l10n.yourOfferMessageLabel} *'
        : '${l10n.messageLabel} *';
    final hint = widget.type == EnquiryFormType.enquiry
        ? l10n.enquiryMessagePlaceholder
        : widget.type == EnquiryFormType.testDrive
            ? l10n.testDriveMessagePlaceholder
            : widget.type == EnquiryFormType.priceNegotiation
                ? l10n.priceNegotiationMessagePlaceholder
                : l10n.enquiryMessagePlaceholder;
    return TextFormField(
      controller: _messageController,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
        filled: true,
        fillColor: isDark ? AppColors.backgroundDark : AppColors.mutedBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? l10n.messageRequired : null,
    );
  }

  String _title(AppLocalizations l10n) {
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        return l10n.enquiryFormTitle;
      case EnquiryFormType.testDrive:
        return l10n.testDriveFormTitle;
      case EnquiryFormType.priceNegotiation:
        return l10n.priceNegotiationFormTitle;
      case EnquiryFormType.exchange:
        return l10n.enquiryFormTitle;
    }
  }

  String _description(AppLocalizations l10n) {
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        return l10n.enquiryFormDescription;
      case EnquiryFormType.testDrive:
        return l10n.testDriveFormDescription;
      case EnquiryFormType.priceNegotiation:
        return l10n.priceNegotiationFormDescription;
      case EnquiryFormType.exchange:
        return l10n.enquiryFormDescription;
    }
  }

  String _submitText(AppLocalizations l10n) {
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        return l10n.submitEnquiryButton;
      case EnquiryFormType.testDrive:
        return l10n.submitTestDriveRequest;
      case EnquiryFormType.priceNegotiation:
        return l10n.submitOffer;
      case EnquiryFormType.exchange:
        return l10n.submitEnquiryButton;
    }
  }
}

/// Bottom-sheet wrapper that provides the sheet styling around [EnquiryFormContent].
class EnquiryFormBottomSheet extends StatelessWidget {
  final int vehicleId;
  final String vehicleTitle;
  final EnquiryFormType type;
  final String? brandName;
  final String? modelName;
  final int? price;

  const EnquiryFormBottomSheet({
    super.key,
    required this.vehicleId,
    required this.vehicleTitle,
    required this.type,
    this.brandName,
    this.modelName,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Obx(() {
      final isDark = appController.isDarkMode.value;
      return Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: EnquiryFormContent(
          vehicleId: vehicleId,
          vehicleTitle: vehicleTitle,
          type: type,
          brandName: brandName,
          modelName: modelName,
          price: price,
        ),
      );
    });
  }
}

import 'dart:convert';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/app_colors.dart';
import '../../../controllers/app_controller/app_controller.dart';
import '../../../repositories/vehicle/vehicle_repository.dart';

enum EnquiryFormType { enquiry, testDrive, priceNegotiation }

class EnquiryFormBottomSheet extends StatefulWidget {
  final int vehicleId;
  final String vehicleTitle;
  final EnquiryFormType type;

  const EnquiryFormBottomSheet({
    super.key,
    required this.vehicleId,
    required this.vehicleTitle,
    required this.type,
  });

  @override
  State<EnquiryFormBottomSheet> createState() => _EnquiryFormBottomSheetState();
}

class _EnquiryFormBottomSheetState extends State<EnquiryFormBottomSheet> {
  final VehicleRepository _repository = VehicleRepository();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  String get _title {
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        return 'Enquiry Form';
      case EnquiryFormType.testDrive:
        return 'Test Drive Request';
      case EnquiryFormType.priceNegotiation:
        return 'Price Negotiation';
    }
  }

  String get _description {
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        return "Submit your enquiry about this vehicle. We'll get back to you as soon as possible.";
      case EnquiryFormType.testDrive:
        return "Request a test drive for this vehicle. We'll get back to you as soon as possible to schedule your test drive.";
      case EnquiryFormType.priceNegotiation:
        return "Make an offer or negotiate the price for this vehicle. We'll get back to you as soon as possible.";
    }
  }

  String get _messagePlaceholder {
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        return "Tell us about your enquiry...";
      case EnquiryFormType.testDrive:
        return "Tell us about your preferred test drive date and time, or any specific questions you have...";
      case EnquiryFormType.priceNegotiation:
        return "Enter your offer price or negotiation message. For example: 'I would like to offer DKK 250,000 for this vehicle' or 'Is there any room for negotiation on the price?'";
    }
  }

  String get _submitText {
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        return 'Submit Enquiry';
      case EnquiryFormType.testDrive:
        return 'Submit Test Drive Request';
      case EnquiryFormType.priceNegotiation:
        return 'Submit Offer';
    }
  }

  @override
  void initState() {
    super.initState();
    _prefillFromUser();
  }

  void _prefillFromUser() {
    final userJson = GetStorage().read('user');
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson.toString()) as Map<String, dynamic>;
        final name = userMap['name'] as String?;
        if (name != null && name.isNotEmpty) {
          _nameController.text = name;
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = GetStorage().read('token')?.toString() ?? '';
    if (token.isEmpty) {
      Get.snackbar(
        'Login Required',
        'Please login to submit an enquiry',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
      Get.offNamed('/login');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final message = _messageController.text.trim();

    late Either<String, Map<String, dynamic>> result;
    switch (widget.type) {
      case EnquiryFormType.enquiry:
        result = await _repository.submitEnquiry(widget.vehicleId, name: name, message: message);
        break;
      case EnquiryFormType.testDrive:
        result = await _repository.submitTestDrive(widget.vehicleId, name: name, message: message);
        break;
      case EnquiryFormType.priceNegotiation:
        result = await _repository.submitPriceNegotiation(widget.vehicleId, name: name, message: message);
        break;
    }

    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        if (error.toLowerCase().contains('unauthorized') || error.toLowerCase().contains('login')) {
          Get.snackbar('Login Required', 'Please login to continue', snackPosition: SnackPosition.BOTTOM);
          Get.back();
          Get.offNamed('/login');
        } else {
          Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
        }
      },
      (_) {
        Get.snackbar(
          'Success',
          widget.type == EnquiryFormType.enquiry
              ? 'Your enquiry has been submitted successfully!'
              : widget.type == EnquiryFormType.testDrive
                  ? 'Your test drive request has been submitted successfully!'
                  : 'Your price negotiation has been submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      },
    );
  }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(isDark),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildVehicleInfo(isDark),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Your name',
                          filled: true,
                          fillColor: isDark ? AppColors.backgroundDark : AppColors.mutedBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          hintText: _messagePlaceholder,
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
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Message is required' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.primaryForeground,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(_submitText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
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
                  _title,
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
            icon: Icon(Icons.close, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(bool isDark) {
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
            'Vehicle',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.vehicleTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

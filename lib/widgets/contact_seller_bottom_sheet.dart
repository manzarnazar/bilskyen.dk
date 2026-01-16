import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/vehicle_model.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';

class ContactSellerBottomSheet extends StatefulWidget {
  final VehicleModel vehicle;

  const ContactSellerBottomSheet({
    super.key,
    required this.vehicle,
  });

  @override
  State<ContactSellerBottomSheet> createState() => _ContactSellerBottomSheetState();
}

class _ContactSellerBottomSheetState extends State<ContactSellerBottomSheet> {
  final TextEditingController _messageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _messageController.text = "Hi Berken, I'm interested in this car. Is it still available?";
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

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
            // Header
            Container(
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
                  const Text(
                    'Contact Seller',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seller Info Section
                    _buildSellerInfoSection(isDark),
                    const SizedBox(height: 32),
                    // Action Buttons
                    _buildActionButtons(isDark),
                    const SizedBox(height: 32),
                    // Send Inquiry Section
                    _buildInquirySection(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSellerInfoSection(bool isDark) {
    return Row(
      children: [
        // Profile Picture with Online Indicator
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray700 : AppColors.gray300,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/seller_profile.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 32,
                    color: isDark ? AppColors.gray400 : AppColors.gray600,
                  ),
                ),
              ),
            ),
            // Online Indicator
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Seller Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Berken Ilkin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    ' (124 Reviews)',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Response time: < 1 hr',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final Uri phoneUri = Uri.parse('tel:+4550143074');
              try {
                if (!await launchUrl(phoneUri, mode: LaunchMode.platformDefault)) {
                  Get.snackbar(
                    'Error',
                    'Could not open phone dialer',
                    snackPosition: SnackPosition.TOP,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Could not open phone dialer',
                  snackPosition: SnackPosition.TOP,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.call, size: 24),
                SizedBox(height: 4),
                Text(
                  'Call Seller',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.snackbar(
                'Chat',
                'Opening chat for ${widget.vehicle.fullName}',
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat, size: 24),
                SizedBox(height: 4),
                Text(
                  'Chat Now',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInquirySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        Container(
          height: 1,
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          margin: const EdgeInsets.only(bottom: 24),
        ),
        // Section Title
        Text(
          'SEND AN INQUIRY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        // Quick Inquiry Buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickInquiryButton('Is this still available?', isDark),
            _buildQuickInquiryButton('Negotiable price?', isDark),
            _buildQuickInquiryButton('Test drive request', isDark),
          ],
        ),
        const SizedBox(height: 16),
        // Message Input
        TextField(
          controller: _messageController,
          maxLines: 3,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
          decoration: InputDecoration(
            hintText: "Hi Berken, I'm interested in this car. Is it still available?",
            hintStyle: TextStyle(
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 16),
        // Send Message Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_messageController.text.trim().isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please enter a message',
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }
              Get.snackbar(
                'Message Sent',
                'Your message has been sent to the seller',
                snackPosition: SnackPosition.TOP,
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Send Message',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.send, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInquiryButton(String text, bool isDark) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _messageController.text = text + '?';
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        side: BorderSide(
          color: Colors.transparent,
        ),
        backgroundColor: isDark ? AppColors.gray800 : AppColors.gray200,
        foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}


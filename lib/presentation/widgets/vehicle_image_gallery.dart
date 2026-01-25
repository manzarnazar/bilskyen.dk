import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/vehicle_detail_model/vehicle_detail_model.dart';
import 'cached_image.dart';

class VehicleImageGallery extends StatefulWidget {
  final List<VehicleImage> images;
  final bool isDark;

  const VehicleImageGallery({
    super.key,
    required this.images,
    required this.isDark,
  });

  @override
  State<VehicleImageGallery> createState() => _VehicleImageGalleryState();
}

class _VehicleImageGalleryState extends State<VehicleImageGallery> {
  late PageController _pageController;
  int _currentPage = 0;

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

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        color: AppColors.carPlaceholderBg,
        child: const Center(
          child: Icon(Icons.directions_car, size: 80, color: AppColors.gray400),
        ),
      );
    }

    return Column(
      children: [
        // Image carousel
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.isDark 
                    ? Colors.black.withOpacity(0.5)
                    : Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    final image = widget.images[index];
                    return CustomCachedImage(
                      imageUrl: image.imageUrl,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                // Left arrow
                if (widget.images.length > 1)
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _previousPage,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            color: AppColors.primary,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Right arrow
                if (widget.images.length > 1)
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.chevron_right,
                            color: AppColors.primary,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Dot indicators
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index
                        ? AppColors.primary
                        : (widget.isDark
                            ? AppColors.mutedDark.withOpacity(0.5)
                            : AppColors.mutedLight.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

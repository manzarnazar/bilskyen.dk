
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/app_colors.dart';


class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  const CustomCachedImage(
      {super.key,
      required this.imageUrl,
      this.fit = BoxFit.cover,
      this.width,
      this.height});
  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      progressIndicatorBuilder: (context, url, progress) {
        return Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
                strokeWidth: 2,
                value: progress.progress,
                color: AppColors.primary,
                ),
          ),
        );
      },
      errorWidget: (context, url, error) => Container(
        color: AppColors.carPlaceholderBg,
        child: const Icon(
          Icons.directions_car,
          size: 80,
          color: AppColors.gray400,
        ),
      ),
    );

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
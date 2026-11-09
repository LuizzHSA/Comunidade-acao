import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? fallbackWidget;

  const CustomImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      imageWidget = Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppTheme.surfaceContainerHigh,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: AppTheme.primary,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return fallbackWidget ??
              Container(
                width: width,
                height: height,
                color: AppTheme.surfaceContainerHigh,
                child: const Center(
                  child: Icon(
                    Icons.volunteer_activism,
                    color: AppTheme.primary,
                    size: 32,
                  ),
                ),
              );
        },
      );
    } else {
      imageWidget = Container(
        width: width,
        height: height,
        color: AppTheme.surfaceContainerHigh,
        child: const Center(
          child: Icon(
            Icons.image,
            color: AppTheme.primary,
            size: 32,
          ),
        ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}


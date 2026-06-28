import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_theme.dart';

/// A reusable, opinionated network image for any TMDB poster or backdrop.
///
/// Goals of this widget:
/// 1. **No surprises** — if the URL is null/empty, we show a solid `darkGrey`
///    block instead of a broken icon. The user is NEVER confused.
/// 2. **Graceful loading** — while the network image streams, we render
///    the same `darkGrey` background (no shimmer/scaffolding deps).
/// 3. **Graceful error** — if the fetch fails (404, no network, etc.), we
///    still render the dark block, with a small `Icons.broken_image` so a
///    developer can spot the issue in `flutter run` logs.
/// 4. **Optional corners** — pass [borderRadius] to clip into rounded cards
///    (used by `MiniMovieCard`).
class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  /// Absolute URL to the image (e.g. `https://image.tmdb.org/t/p/w500/...`).
  /// When null or empty, the widget renders an empty dark block.
  final String? url;

  /// How the image should be inscribed into the available space.
  /// Defaults to `BoxFit.cover` (Netflix-style fill + crop).
  final BoxFit fit;

  /// Optional rounded corners (e.g. for the mini poster card).
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    // Case 1: no URL — render a single solid block, no fluff.
    if (url == null || url!.isEmpty) {
      return Container(color: AppTheme.darkGrey);
    }

    // Case 2: build the network image with placeholder + error fallbacks.
    final image = CachedNetworkImage(
      imageUrl: url!,
      fit: fit,
      // While the image is streaming, show a solid background.
      placeholder: (_, __) => Container(color: AppTheme.darkGrey),
      // If the URL 404s or the device has no network, show a tiny hint
      // icon — better than a permanent blank square.
      errorWidget: (_, __, ___) => Container(
        color: AppTheme.darkGrey,
        alignment: Alignment.center,
        child: const Icon(
          Icons.broken_image,
          color: AppTheme.lightGrey,
          size: 32,
        ),
      ),
    );

    // Optional rounded clip applied AFTER the image is laid out so the
    // rounded corners look correct under both loading and loaded states.
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

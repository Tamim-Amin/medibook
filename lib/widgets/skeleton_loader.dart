import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_theme.dart';
import '../utils/context_colors.dart';

/// Wraps its child in a shimmer animation.
///
/// Wrap a whole list once rather than each box individually — one animation
/// controller instead of many.
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.cShimmerBase,
      highlightColor: context.cShimmerHighlight,
      child: child,
    );
  }
}

/// A grey placeholder block. Only meaningful inside a [SkeletonLoader].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.cShimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Placeholder matching the layout of [DoctorCard].
class DoctorCardSkeleton extends StatelessWidget {
  const DoctorCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: context.cBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                SkeletonBox(width: 60, height: 60, radius: 16),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SkeletonBox(width: 150, height: 15),
                      SizedBox(height: 8),
                      SkeletonBox(width: 100, height: 12),
                      SizedBox(height: 8),
                      SkeletonBox(width: 180, height: 11),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SkeletonBox(height: 30, radius: 8),
          ],
        ),
      ),
    );
  }
}

/// Placeholder matching the layout of [AppointmentCard].
class AppointmentCardSkeleton extends StatelessWidget {
  const AppointmentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: context.cBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            SkeletonBox(width: 170, height: 15),
            SizedBox(height: 8),
            SkeletonBox(width: 220, height: 11),
            SizedBox(height: 16),
            SkeletonBox(width: 120, height: 12),
            SizedBox(height: 12),
            SkeletonBox(width: 200, height: 24, radius: 20),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for a price list row.
class PriceItemSkeleton extends StatelessWidget {
  const PriceItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.cSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: context.cBorder),
        ),
        child: Row(
          children: const <Widget>[
            SkeletonBox(width: 40, height: 40, radius: 10),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SkeletonBox(width: 140, height: 13),
                  SizedBox(height: 6),
                  SkeletonBox(width: 80, height: 10),
                ],
              ),
            ),
            SizedBox(width: 10),
            SkeletonBox(width: 50, height: 15),
          ],
        ),
      ),
    );
  }
}

/// Convenience: a vertical list of [count] skeleton cards.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.count = 4,
    this.itemBuilder,
    this.spacing = 12,
  });

  final int count;
  final WidgetBuilder? itemBuilder;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (BuildContext context, int index) =>
          itemBuilder?.call(context) ?? const DoctorCardSkeleton(),
    );
  }
}

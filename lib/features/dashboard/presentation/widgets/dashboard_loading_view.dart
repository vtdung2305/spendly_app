import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/loading/app_loading_indicator.dart';

/// Shimmer blocks in place of chart cards and list rows, per Dashboard
/// "Loading" state.
class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.mdLg,
      ),
      children: const [
        AppShimmerBlock(height: 40, width: 160),
        SizedBox(height: AppSpacing.mdLg),
        AppShimmerBlock(height: 150, radius: 20),
        SizedBox(height: AppSpacing.cardGap),
        AppShimmerBlock(height: 80, radius: 20),
        SizedBox(height: AppSpacing.cardGap),
        AppShimmerBlock(height: 120, radius: 20),
        SizedBox(height: AppSpacing.cardGap),
        AppShimmerBlock(height: 90, radius: 20),
        SizedBox(height: AppSpacing.cardGap),
        AppShimmerBlock(height: 60),
        SizedBox(height: AppSpacing.smMd),
        AppShimmerBlock(height: 60),
        SizedBox(height: AppSpacing.smMd),
        AppShimmerBlock(height: 60),
      ],
    );
  }
}

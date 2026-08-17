import 'package:flutter/material.dart';

import '../../models/diagnostic_center.dart';
import '../../models/price_item.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../widgets/avatar_image.dart';
import '../../widgets/diagnostics_price_card.dart';
import '../../widgets/skeleton_loader.dart';

/// One diagnostic centre, with its Tests and Pharmacy price lists.
class CenterDetailsScreen extends StatefulWidget {
  const CenterDetailsScreen({super.key, required this.center});

  final DiagnosticCenter center;

  @override
  State<CenterDetailsScreen> createState() => _CenterDetailsScreenState();
}

class _CenterDetailsScreenState extends State<CenterDetailsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (mounted) setState(() => _isLoading = false);
  }

  /// Picks a sensible icon from the test name so the list is scannable
  /// without needing an icon field on every demo item.
  static IconData iconForTest(String name) {
    final String n = name.toLowerCase();
    if (n.contains('ecg') || n.contains('echo')) return Icons.monitor_heart_outlined;
    if (n.contains('x-ray')) return Icons.medical_information_outlined;
    if (n.contains('mri') || n.contains('ct scan')) return Icons.scanner_outlined;
    if (n.contains('ultrason')) return Icons.pregnant_woman_outlined;
    if (n.contains('blood') || n.contains('cbc') || n.contains('lipid')) {
      return Icons.bloodtype_outlined;
    }
    if (n.contains('urine')) return Icons.science_outlined;
    return Icons.biotech_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final DiagnosticCenter center = widget.center;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Centre Details'),
          bottom: TabBar(
            labelColor: context.cPrimary,
            unselectedLabelColor: context.cTextSecondary,
            indicatorColor: context.cPrimary,
            labelStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            tabs: <Widget>[
              Tab(text: 'Tests (${center.tests.length})'),
              Tab(text: 'Pharmacy (${center.medicines.length})'),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: _CenterHeader(center: center),
            ),
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 6,
                      itemBuilder: (_, _) => const PriceItemSkeleton(),
                    )
                  : TabBarView(
                      children: <Widget>[
                        _PriceList(
                          items: center.tests,
                          iconBuilder: iconForTest,
                          accent: AppColors.primary,
                        ),
                        _PriceList(
                          items: center.medicines,
                          iconBuilder: (_) => Icons.medication_outlined,
                          accent: AppColors.accent,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterHeader extends StatelessWidget {
  const _CenterHeader({required this.center});

  final DiagnosticCenter center;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cSurface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: context.cBorder),
      ),
      child: Row(
        children: <Widget>[
          AvatarImage(
            initials: center.initials,
            imageAsset: center.imageAsset,
            size: 54,
            color: AppColors.accent,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  center.name,
                  style: AppTextStyles.heading3
                      .copyWith(color: context.cTextPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  center.location,
                  style: AppTextStyles.caption
                      .copyWith(color: context.cTextSecondary),
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.warning),
                    const SizedBox(width: 3),
                    Text(
                      center.rating.toStringAsFixed(1),
                      style: AppTextStyles.caption
                          .copyWith(color: context.cTextPrimary),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.schedule_outlined,
                        size: 13, color: context.cTextSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        center.openingHours,
                        style: AppTextStyles.caption
                            .copyWith(color: context.cTextSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceList extends StatelessWidget {
  const _PriceList({
    required this.items,
    required this.iconBuilder,
    required this.accent,
  });

  final List<PriceItem> items;
  final IconData Function(String) iconBuilder;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int i) {
        final PriceItem item = items[i];
        return DiagnosticsPriceCard(
          item: item,
          icon: iconBuilder(item.name),
          accentColor: accent,
        );
      },
    );
  }
}

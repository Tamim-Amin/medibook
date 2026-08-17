import 'package:flutter/material.dart';

import '../../data/demo_diagnostics.dart';
import '../../models/diagnostic_center.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/context_colors.dart';
import '../../widgets/center_card.dart';
import '../../widgets/skeleton_loader.dart';

/// Nearby diagnostic centres and their price lists.
class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  bool _isLoading = true;
  List<DiagnosticCenter> _centers = <DiagnosticCenter>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _centers = kDemoCenters;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostics')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
          children: <Widget>[
            Text(
              'Check test and medicine prices before you visit',
              style: AppTextStyles.bodySmall
                  .copyWith(color: context.cTextSecondary),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              ...List<Widget>.generate(
                3,
                    (_) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: DoctorCardSkeleton(),
                ),
              )
            else
              ..._centers.map(
                    (DiagnosticCenter center) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CenterCard(
                    center: center,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.centerDetails,
                      arguments: center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
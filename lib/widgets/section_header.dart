import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';
import '../utils/context_colors.dart';

/// Row heading used above list sections — "Top Doctors" + "See all".
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.heading3.copyWith(color: context.cTextPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.caption.copyWith(color: context.cPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/price_item.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';
import '../utils/context_colors.dart';

/// A single row in the Tests / Pharmacy price list.
class DiagnosticsPriceCard extends StatelessWidget {
  const DiagnosticsPriceCard({
    super.key,
    required this.item,
    required this.icon,
    this.accentColor,
  });

  final PriceItem item;
  final IconData icon;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? context.cPrimary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.cSurface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: context.cBorder),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style:
                      AppTextStyles.body.copyWith(color: context.cTextPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.unit != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    item.unit!,
                    style: AppTextStyles.caption
                        .copyWith(color: context.cTextSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(item.priceLabel, style: AppTextStyles.price),
        ],
      ),
    );
  }
}

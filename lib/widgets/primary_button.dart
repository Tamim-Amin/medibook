import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';

/// The app's standard action button.
///
/// Use [isOutlined] for secondary actions and [isLoading] to block repeat taps
/// while an async operation runs.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.button.copyWith(
                    color: isOutlined
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final VoidCallback? handler = isLoading ? null : onPressed;

    final Widget button = isOutlined
        ? OutlinedButton(onPressed: handler, child: child)
        : ElevatedButton(onPressed: handler, child: child);

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

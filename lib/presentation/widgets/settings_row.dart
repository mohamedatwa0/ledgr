import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.enabled = true,
    this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? inkNavy : mutedInk.withValues(alpha: 0.55);
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(bottom: BorderSide(color: ruleColor, width: 1))
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: uiStyle(fontSize: 14, color: color)),
              ),
              trailing ??
                  Icon(TablerIcons.chevron_right, size: 18, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

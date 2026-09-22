import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';
import 'directional_icon.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    this.onTap,
    this.showDivider = true,
    this.iconColor,
    this.iconBackground,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? iconColor;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color =
        enabled ? colors.onSurface : colors.secondary.withValues(alpha: 0.55);
    return Opacity(
      opacity: enabled ? 1 : 0.75,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 14.h, 16.w, 14.h),
          decoration: BoxDecoration(
            color: colors.paperLight,
            border: showDivider
                ? Border(bottom: BorderSide(color: colors.rule, width: 1.w))
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBackground ?? colors.surfaceContainer,
                ),
                child: Icon(
                  icon,
                  size: 18.r,
                  color: iconColor ?? colors.primary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: uiStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: uiStyle(fontSize: 12, color: colors.secondary),
                      ),
                  ],
                ),
              ),
              trailing ??
                  DirectionalIcon(
                    TablerIcons.chevron_right,
                    size: 20.r,
                    color: colors.secondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

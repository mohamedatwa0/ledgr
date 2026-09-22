import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LedgrBottomNav extends StatelessWidget {
  const LedgrBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final items = [
      (icon: TablerIcons.book, label: l10n.navDashboard, key: 'tab-dashboard'),
      (
        icon: TablerIcons.receipt,
        label: l10n.navTransactions,
        key: 'tab-transactions'
      ),
      (
        icon: TablerIcons.adjustments,
        label: l10n.navSettings,
        key: 'tab-settings'
      ),
    ];
    return Material(
      color: colors.paperLight.withValues(alpha: 0.95),
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.rule)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64.h,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavItem(
                      key: Key(items[i].key),
                      icon: items[i].icon,
                      label: items[i].label,
                      selected: currentIndex == i,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.primaryContainer : colors.secondary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22.r, color: color),
          SizedBox(height: 2.h),
          Text(
            label,
            style: uiStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: color,
              letterSpacing: ltrLetterSpacing(context, 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

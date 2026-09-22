import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import 'ledgr_bottom_nav.dart';
import 'ledgr_header.dart';

class LedgrShell extends StatelessWidget {
  const LedgrShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;
    final colors = context.colors;
    final l10n = context.l10n;
    final sections = [
      l10n.navDashboard,
      l10n.navTransactions,
      l10n.navSettings,
    ];
    return Scaffold(
      body: Column(
        children: [
          LedgrHeader(section: sections[index]),
          Expanded(child: navigationShell),
        ],
      ),
      floatingActionButton: index == 2
          ? null
          : SizedBox(
              width: 56.w,
              height: 56.h,
              child: FloatingActionButton(
                key: const Key('add-transaction-fab'),
                tooltip: l10n.newEntryTooltip,
                onPressed: () => context.push('/transaction/new'),
                child: Icon(TablerIcons.plus, size: 28.r),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: LedgrBottomNav(
        currentIndex: index,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
      backgroundColor: colors.surface,
    );
  }
}

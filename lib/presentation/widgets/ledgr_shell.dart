import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import 'add_entry_fab.dart';
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
      floatingActionButton: index == 2 ? null : const AddEntryFab(),
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

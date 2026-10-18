import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import 'add_entry_fab.dart';
import 'ledgr_bottom_nav.dart';
import 'ledgr_header.dart';

class LedgrShell extends StatefulWidget {
  const LedgrShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<LedgrShell> createState() => _LedgrShellState();
}

class _LedgrShellState extends State<LedgrShell> {
  final _fabKey = GlobalKey<AddEntryFabState>();
  var _fabExpanded = false;

  @override
  Widget build(BuildContext context) {
    final index = widget.navigationShell.currentIndex;
    final colors = context.colors;
    final l10n = context.l10n;
    final sections = [
      l10n.navDashboard,
      l10n.navTransactions,
      l10n.navSettings,
    ];
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              LedgrHeader(section: sections[index]),
              Expanded(child: widget.navigationShell),
            ],
          ),
          if (_fabExpanded && index != 2)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _fabKey.currentState?.collapse(),
                behavior: HitTestBehavior.opaque,
                child: const ColoredBox(color: Color(0x00000000)),
              ),
            ),
        ],
      ),
      floatingActionButton: index == 2
          ? null
          : AddEntryFab(
              key: _fabKey,
              onExpandedChanged: (expanded) {
                if (_fabExpanded == expanded) return;
                setState(() => _fabExpanded = expanded);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: LedgrBottomNav(
        currentIndex: index,
        onTap: (i) => widget.navigationShell.goBranch(
          i,
          initialLocation: false,
        ),
      ),
      backgroundColor: colors.surface,
    );
  }
}

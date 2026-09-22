import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/presentation/widgets/ledgr_launch_screen.dart';
import 'package:ledgr/theme/theme.dart';

void main() {
  testWidgets('launch svg paints above the slogan', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    final info = await vg.loadPicture(
      SvgAssetLoader(
        'assets/branding/ledger_icon.svg',
        assetBundle: rootBundle,
      ),
      null,
    );
    addTearDown(info.picture.dispose);

    final key = GlobalKey();
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          theme: ledgrLightTheme,
          home: RepaintBoundary(
            key: key,
            child: LedgrLaunchScreen(
              picture: info.picture,
              pictureSize: info.size,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Simply Track. Simply Know.'), findsOneWidget);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await tester.binding.runAsync(() => boundary.toImage());
    final bytes = await tester.binding.runAsync(
      () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
    );
    final data = bytes!.buffer.asUint8List();
    var navy = 0;
    for (var i = 0; i < data.length; i += 4) {
      final r = data[i];
      final g = data[i + 1];
      final b = data[i + 2];
      if (data[i + 3] < 200) continue;
      if (r < 50 && g < 70 && b < 90) navy++;
    }
    expect(info.size, isNot(Size.zero));
    expect(navy, greaterThan(50));
  });
}

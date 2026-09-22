import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/domain/date_utils.dart';

void main() {
  group('parseMinorUnits', () {
    test('parses whole amounts', () {
      expect(parseMinorUnits('45'), 4500);
    });

    test('parses dotted decimals', () {
      expect(parseMinorUnits('45.00'), 4500);
      expect(parseMinorUnits('45.5'), 4550);
    });

    test('parses comma decimals', () {
      expect(parseMinorUnits('45,00'), 4500);
      expect(parseMinorUnits('12,34'), 1234);
    });

    test('rounds half away from zero', () {
      expect(parseMinorUnits('45.005'), 4501);
      expect(parseMinorUnits('45.004'), 4500);
    });

    test('parses Arabic-Indic digits', () {
      expect(parseMinorUnits('٤٥'), 4500);
      expect(parseMinorUnits('٤٥.٥٠'), 4550);
    });

    test('returns null for empty or invalid input', () {
      expect(parseMinorUnits(''), isNull);
      expect(parseMinorUnits('   '), isNull);
      expect(parseMinorUnits('abc'), isNull);
    });
  });

  test('minorToInput formats two decimals', () {
    expect(minorToInput(4500), '45.00');
    expect(minorToInput(1234), '12.34');
  });
}

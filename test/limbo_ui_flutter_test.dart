import 'package:flutter_test/flutter_test.dart';
import 'package:limbo_ui_flutter/limbo_ui_flutter.dart';

void main() {
  group('LimboColors', () {
    test('primary color has correct value', () {
      expect(LimboColors.primary.toARGB32(), 0xFF19b4b3);
    });
  });

  group('LimboTextStyles', () {
    test('button style has correct font size', () {
      expect(LimboTextStyles.button.fontSize, 16);
    });
  });
}

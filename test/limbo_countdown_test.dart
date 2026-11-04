import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:limbo_ui_flutter/limbo_ui_flutter.dart';

void main() {
  group('LimboCountdown logic', () {
    test('remaining is never negative', () {
      final deadline = DateTime.utc(2026, 1, 1, 10);
      expect(
        LimboCountdown.remaining(deadline, DateTime.utc(2026, 1, 1, 9, 59)),
        const Duration(minutes: 1),
      );
      expect(
        LimboCountdown.remaining(deadline, DateTime.utc(2026, 1, 1, 11)),
        Duration.zero,
      );
    });

    test('format switches to h:mm:ss from one hour', () {
      expect(LimboCountdown.format(const Duration(minutes: 5, seconds: 7)), '05:07');
      expect(LimboCountdown.format(Duration.zero), '00:00');
      expect(
        LimboCountdown.format(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1:02:03',
      );
    });
  });

  testWidgets('shows the time left and fires onExpired once', (tester) async {
    var now = DateTime.utc(2026, 1, 1, 10);
    var expired = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: LimboCountdown(
          deadline: DateTime.utc(2026, 1, 1, 10, 0, 3),
          clock: () => now,
          onExpired: () => expired++,
        ),
      ),
    );
    expect(find.text('Vence en 00:03'), findsOneWidget);

    now = DateTime.utc(2026, 1, 1, 10, 0, 5);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Venció'), findsOneWidget);
    expect(expired, 1);

    await tester.pump(const Duration(seconds: 2));
    expect(expired, 1);
  });
}

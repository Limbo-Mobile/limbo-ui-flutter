import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:limbo_ui_flutter/limbo_ui_flutter.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('adds a photo through onPick and reports the new list', (tester) async {
    List<String> latest = const [];
    await tester.pumpWidget(_host(
      LimboPhotoStrip(
        maxPhotos: 2,
        onPick: () async => 'https://cdn.example/a.webp',
        onChanged: (urls) => latest = urls,
      ),
    ));

    expect(find.text('Fotos (0/2)'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
    await tester.pumpAndSettle();

    expect(latest, ['https://cdn.example/a.webp']);
    expect(find.text('Fotos (1/2)'), findsOneWidget);
  });

  testWidgets('hides the add tile at the limit and removes photos', (tester) async {
    List<String> latest = const ['x'];
    await tester.pumpWidget(_host(
      LimboPhotoStrip(
        maxPhotos: 1,
        initialUrls: const ['https://cdn.example/a.webp'],
        onPick: () async => null,
        onChanged: (urls) => latest = urls,
      ),
    ));

    expect(find.byIcon(Icons.add_a_photo_outlined), findsNothing);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(latest, isEmpty);
    expect(find.byIcon(Icons.add_a_photo_outlined), findsOneWidget);
  });

  testWidgets('cancelled pick adds nothing; failures are reported', (tester) async {
    String? error;
    var fail = false;
    await tester.pumpWidget(_host(
      LimboPhotoStrip(
        onPick: () async {
          if (fail) throw ApiException('Archivo muy pesado');
          return null;
        },
        onChanged: (_) {},
        onError: (message) => error = message,
      ),
    ));

    await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Fotos (0/3)'), findsOneWidget);
    expect(error, isNull);

    fail = true;
    await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
    await tester.pumpAndSettle();
    expect(error, 'Archivo muy pesado');
    expect(find.text('Fotos (0/3)'), findsOneWidget);
  });

  testWidgets('LimboNetworkImage shows the placeholder for an empty url', (tester) async {
    await tester.pumpWidget(_host(
      const LimboNetworkImage('', errorIcon: Icons.category_outlined),
    ));
    expect(find.byIcon(Icons.category_outlined), findsOneWidget);
  });
}

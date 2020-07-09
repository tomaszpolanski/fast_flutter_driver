import 'package:fast_flutter_driver/src/delayed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('widget is shown after delay', (tester) async {
    const duration = Duration(seconds: 10);
    await tester.pumpWidget(
      const Delayed(
        // ignore: avoid_redundant_argument_values
        delay: duration,
        child: Placeholder(),
      ),
    );

    await tester.pumpAndSettle(duration);

    expect(find.byType(Placeholder), findsOneWidget);
  });

  testWidgets('widget is not shown before the delay', (tester) async {
    const duration = Duration(seconds: 10);
    await tester.pumpWidget(
      const Delayed(
        // ignore: avoid_redundant_argument_values
        delay: duration,
        child: Placeholder(),
      ),
    );

    await tester.pump(duration - const Duration(seconds: 1));

    expect(find.byType(Placeholder), findsNothing);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets('debugFillProperties', (tester) async {
    const delay = Duration(seconds: 11);
    const widget = Delayed(
      delay: delay,
      child: Placeholder(),
    );
    final tested = DiagnosticPropertiesBuilder();

    widget.debugFillProperties(tested);

    final DiagnosticsProperty<Duration> property = tested.properties.first;
    expect(property.value, delay);
  });

  group('argument cannot be null', () {
    testWidgets('delay', (tester) async {
      expect(
        () => Delayed(
          delay: null,
          child: const Placeholder(),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('child', (tester) async {
      expect(
        () => Delayed(child: null),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}

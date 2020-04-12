import 'package:fast_flutter_driver/src/delayed.dart';
import 'package:flutter/cupertino.dart';
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
}

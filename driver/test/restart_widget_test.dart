import 'dart:async';

import 'package:fast_flutter_driver/driver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('nothing is displayed until widget is restarted', (tester) async {
    const mainKey = Key('main');
    await tester.pumpWidget(
      RestartWidget<String>(
        builder: (_, config) => Text(
          config,
          key: mainKey,
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 100));

    expect(find.byKey(mainKey), findsNothing);
  });

  testWidgets('displays widget with new configuration', (tester) async {
    const mainKey = Key('main');
    const configuration = 'test message';
    await tester.pumpWidget(
      RestartWidget<String>(
        builder: (_, config) => Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            config,
            key: mainKey,
          ),
        ),
      ),
    );
    scheduleMicrotask(() {
      RestartWidget.restartApp(configuration);
    });

    await tester.pumpAndSettle(const Duration(seconds: 100));

    expect(find.byKey(mainKey), findsOneWidget);
    expect(find.text(configuration), findsOneWidget);
  });

  testWidgets('setting initial value', (tester) async {
    const mainKey = Key('main');
    const configuration = 'test message';
    await tester.pumpWidget(
      RestartWidget<String>(
        initial: configuration,
        builder: (_, config) => Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            config,
            key: mainKey,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(mainKey), findsOneWidget);
    expect(find.text(configuration), findsOneWidget);
  });
}

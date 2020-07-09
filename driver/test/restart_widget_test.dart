import 'dart:async';

import 'package:fast_flutter_driver/driver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  testWidgets('debugFillProperties', (tester) async {
    const configuration = 'test message';
    const color = Colors.pink;
    final widget = RestartWidget<String>(
      initial: configuration,
      backgroundColor: color,
      builder: (_, config) => const Directionality(
        textDirection: TextDirection.ltr,
        child: Placeholder(),
      ),
    );
    final tested = DiagnosticPropertiesBuilder();

    widget.debugFillProperties(tested);
    final DiagnosticsProperty<String> initial = tested.properties[0];
    expect(initial.value, configuration);
    final ColorProperty backgroundColor = tested.properties[1];
    expect(backgroundColor.value, color);
  });
}

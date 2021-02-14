import 'dart:math';

import 'package:example/pages/base_page.dart';
import 'package:example/pages/page_1.dart';
import 'package:example/pages/page_2.dart';
import 'package:example/pages/page_3.dart';
import 'package:example/pages/page_4.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key key, this.route}) : super(key: key);

  final String route;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: route ?? routes.page1,
      onUnknownRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BasePage(
            title: route,
            color: Color.lerp(Colors.red, Colors.orange, Random().nextDouble()),
          ),
        );
      },
      routes: {
        routes.page1: (_) => const Page1(),
        routes.page2: (_) => const Page2(),
        routes.page3: (_) => const Page3(),
        routes.page4: (_) => const Page4(),
      },
    );
  }
}

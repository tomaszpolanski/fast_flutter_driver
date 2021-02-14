import 'package:example/pages/base_page.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter/material.dart';

class Page4 extends StatelessWidget {
  const Page4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: routes.page4,
      color: Colors.red,
    );
  }
}

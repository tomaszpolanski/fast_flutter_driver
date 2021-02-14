import 'package:example/pages/base_page.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: routes.page1,
      color: Colors.orange,
    );
  }
}

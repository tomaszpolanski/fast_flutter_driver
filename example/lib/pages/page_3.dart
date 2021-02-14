import 'package:example/pages/base_page.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const Page3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: routes.page3,
      color: Colors.red,
    );
  }
}

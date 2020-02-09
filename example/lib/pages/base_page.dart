import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    Key key,
    @required this.title,
    @required this.color,
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Text(
          title,
          // TODO(tomek) switch to headline5 when stable is 1.14.6+
          // ignore: deprecated_member_use
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }
}

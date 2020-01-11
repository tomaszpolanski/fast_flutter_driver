import 'package:fast_flutter_driver/src/src/tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class RestartWidget extends StatefulWidget {
  const RestartWidget({
    @required this.builder,
    Key key,
  }) : super(key: key);

  final Widget Function(BuildContext, TestConfiguration) builder;

  static Future<void> restartApp(TestConfiguration configuration) {
    final state = _RestartWidgetState.global.currentContext
        .findAncestorStateOfType<_RestartWidgetState>();
    return state.restartApp(configuration);
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  bool _restarting = false;
  TestConfiguration _configuration;
  static final global = GlobalKey<_RestartWidgetState>();

  Future<void> restartApp(TestConfiguration configuration) async {
    setState(() {
      _restarting = true;
      _configuration = configuration;
    });

    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    setState(() => _restarting = false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: global,
      child: _restarting
          ? const SizedBox()
          : _configuration == null
              ? _StartingTests()
              : widget.builder(context, _configuration),
    );
  }
}

class _StartingTests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Starting Tests in:',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 20),
            _CountDown(),
          ],
        ),
      ),
    );
  }
}

class _CountDown extends StatelessWidget {
  final _countdown = [
    ...List.generate(8, (index) => '${5 - index}'),
    '🤓',
    '🐹',
    '🖥️',
    '🕹',
    '📱',
    '🤔',
    '🥓',
    '🦊',
    '🤖',
    '🍎',
    '🗔',
    '🐧',
    '⌨',
    '🍣',
    '🍀',
    '🐬',
    '🦁',
    '🐘',
    '🥇',
    '🏐',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder(
        stream: Observable.fromIterable(_countdown).asyncMap((text) async =>
            Future.delayed(const Duration(seconds: 1), () => text)),
        initialData: '',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Text(
            snapshot.data,
            style: const TextStyle(fontSize: 80),
          );
        },
      ),
    );
  }
}

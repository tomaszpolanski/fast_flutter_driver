import 'package:fast_flutter_driver/src/src/tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class RestartWidget<T> extends StatefulWidget {
  const RestartWidget({
    @required this.builder,
    this.initial,
    Key key,
  }) : super(key: key);

  final T initial;
  final Widget Function(BuildContext, BaseConfiguration) builder;

  static Future<void> restartApp<T extends BaseConfiguration>(T configuration) {
    final state = _RestartWidgetState.global.currentContext
        .findAncestorStateOfType<_RestartWidgetState>();
    return state.restartApp(configuration);
  }

  @override
  _RestartWidgetState<T> createState() => _RestartWidgetState<T>();
}

class _RestartWidgetState<T> extends State<RestartWidget> {
  bool _restarting = false;
  T _configuration;
  static final global = GlobalKey<_RestartWidgetState>();

  Future<void> restartApp(T configuration) async {
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
          : (_configuration ?? widget.initial) == null
              ? _StartingTests()
              : widget.builder(context, _configuration ?? widget.initial),
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

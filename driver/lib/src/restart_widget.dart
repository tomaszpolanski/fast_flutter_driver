import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RestartWidget<T> extends StatefulWidget {
  const RestartWidget({
    @required this.builder,
    this.initial,
    this.backgroundColor,
    Key key,
  }) : super(key: key);

  final T initial;

  /// The color of the background when switching between tests
  /// If not set, the background will be black
  final Color backgroundColor;
  final Widget Function(BuildContext, T) builder;

  static Future<void> restartApp<T>(T configuration) {
    final state = _RestartWidgetState.global.currentContext
        .findAncestorStateOfType<_RestartWidgetState<T>>();
    return state.restartApp(configuration);
  }

  @override
  _RestartWidgetState<T> createState() => _RestartWidgetState<T>();
}

class _RestartWidgetState<T> extends State<RestartWidget<T>> {
  bool _restarting = false;
  T _configuration;
  static final global = GlobalKey();

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
          ? widget.backgroundColor != null
              ? Container(color: widget.backgroundColor)
              : const SizedBox()
          : (widget.initial ?? _configuration) == null
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
        stream: Stream.fromIterable(_countdown).asyncMap((text) async =>
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

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Delayed extends StatelessWidget {
  const Delayed({
    this.delay = const Duration(seconds: 10),
    required this.child,
    Key? key,
  }) : super(key: key);

  final Duration delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Future<void>.delayed(delay),
      builder: (_, snapshot) => snapshot.connectionState == ConnectionState.done
          ? child
          : const SizedBox(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>('delay', delay));
  }
}

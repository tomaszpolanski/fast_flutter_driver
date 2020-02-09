import 'package:fast_flutter_driver/src/window_utils/window_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WindowsFrame extends StatelessWidget {
  const WindowsFrame({
    Key key,
    @required this.child,
    @required this.active,
    this.border,
  }) : super(key: key);

  final Widget child;
  final bool active;
  final BoxBorder border;

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return child;
    }
    const width = 4.0;
    const height = 4.0;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (border != null)
          Container(
            decoration: BoxDecoration(border: border),
            child: child,
          )
        else
          child,
        Positioned(
          top: 0,
          left: width,
          right: width,
          height: height,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.top),
          ),
        ),
        Positioned(
          bottom: 0,
          left: width,
          right: width,
          height: height,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.bottom),
          ),
        ),
        Positioned(
          bottom: height,
          top: height,
          right: 0,
          width: width,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.right),
          ),
        ),
        Positioned(
          bottom: height,
          top: height,
          left: 0,
          width: width,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.left),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          height: height,
          width: width,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.topLeft),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          height: height,
          width: width,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.topRight),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          height: height,
          width: width,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.bottomLeft),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          height: height,
          width: width,
          child: GestureDetector(
            onTapDown: (_) => WindowUtils.startResize(DragPosition.bottomRight),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('active', active))
      ..add(DiagnosticsProperty<BoxBorder>('border', border));
  }
}

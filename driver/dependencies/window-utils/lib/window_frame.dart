import 'package:flutter/material.dart';
import 'package:window_utils/window_utils.dart';

class WindowsFrame extends StatelessWidget {
  final Widget child;
  final bool active;
  final BoxBorder border;

  const WindowsFrame({
    Key key,
    @required this.child,
    @required this.active,
    this.border,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!active) return child;
    final width = 4.0;
    final height = 4.0;
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          border != null
              ? Container(
                  decoration: BoxDecoration(border: border),
                  child: child,
                )
              : child,
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
              onTapDown: (_) =>
                  WindowUtils.startResize(DragPosition.bottomLeft),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            height: height,
            width: width,
            child: GestureDetector(
              onTapDown: (_) =>
                  WindowUtils.startResize(DragPosition.bottomRight),
            ),
          ),
        ],
      ),
    );
  }
}

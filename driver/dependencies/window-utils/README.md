# window_utils

A Flutter plugin for Desktop that controls the window instance.

## Installing

- Install the package from https://pub.dev in your pubspec.yaml

```yaml
dependencies:
  window_utils: any
```

or the latest from git

```yaml
dependencies:
  window_utils:
    git: https://github.com/rive-app/window-utils
```

### MacOS

Nothing needed, already good to go!

### Linux

Follow this guide on how to work with desktop plugins for linux:

https://github.com/google/flutter-desktop-embedding/tree/master/plugins

### Windows

Follow this guide on how to work with desktop plugins for windows:

https://github.com/google/flutter-desktop-embedding/tree/master/plugins


## Usage

These are the various api calls and are subject to change in the future.

#### Hide the desktop title bar

> When you do this you will loose drag window functionality. (But there is a solution for that below). On Windows you also loose default resize and tool bar buttons (see below)

```dart
WindowUtils.hideTitleBar();

// If used on app launch wrap it this way:
WidgetsBinding.instance.addPostFrameCallback(
   (_) => WindowUtils.hideTitleBar(),
);
```

![no_title](https://github.com/rive-app/window_utils/blob/master/doc/macos.png?raw=true)

#### Show the default title bar

> This will also give you options on customizing the default toolbar in the future

```dart
WindowUtils.showTitleBar();
```

#### Close the window

> Required to implement if you hide the title bar

This executes a close command to the window. It can still be restored by the OS if enabled.

```dart
WindowUtils.showTitleBar();
```

#### Minimize the window

> WINDOWS ONLY

> Required to implement if you hide the title bar

This will minimize the window if you hide the title bar and/or have a custom minimize button.

```dart
WindowUtils.minWindow();
```

#### Maximize the window

> WINDOWS ONLY

> Required to implement if you hide the title bar

This will maximize the window if you hide the title bar and/or have a custom maximize button.

```dart
WindowUtils.maxWindow();
```

#### Center the window

This will center the window.

```dart
WindowUtils.maxWindow();
```

#### Set the window position

This will position the window in relation to the display it is rendered in.

You need to provide `Offset` that is the top left corner of the screen. You can get the current offset by calling `WindowUtils.getWindowOffset()`.

```dart
WindowUtils.setPosition(Offset offset);
```

#### Set the window size

This will size the window in relation to the display it is rendered in.

You need to provide `Size` that is the width and height of the screen. You can get the current size by calling `WindowUtils.getWindowSize()`.

```dart
WindowUtils.setSize(Size size);
```

#### Drag the window

> Required to implement if you hide the title bar

This will drag the window. You can call this to move the window around the screen and pass the mouse event to the native platform.

```dart
WindowUtils.startDrag();
```

#### Drag to resize the window

This will drag resize the window. You can call this to resize the window on the screen and pass the mouse event to the native platform.

You need to provide `DragPosition` to tell the native platform where you are dragging from. 

```dart
enum DragPosition {
  top,
  left,
  right,
  bottom,
  topLeft,
  bottomLeft,
  topRight,
  bottomRight
}
```

Included in the package is `import 'package:window_utils/window_frame.dart';` a `WindowsFrame` that includes the calls for you with a transparent border to handle the events. See the example for more details.

```dart
startResize(DragPosition position);
```

#### Double tap title bar command

> Required to implement if you hide the title bar

This will call the native platform command for when you double tap on a title bar.

```dart
WindowUtils.windowTitleDoubleTap();
```

#### Child window count

This will return a `int` count of all the children windows currently open.

```dart
WindowUtils.childWindowsCount();
```

#### Get display screen size

This will return a `Size` size of the display window that the application is running in.

```dart
WindowUtils.getScreenSize();
```

#### Get application screen size

This will return a `Size` size of the application window that is running.

```dart
WindowUtils.getWindowSize();
```

#### Get application position

This will return a `Offset` offset of the application window that is running.

```dart
WindowUtils.getWindowOffset();
```

#### Set Mouse Cursor

> MACOS ONLY

Update the system cursor.

You need to provide `CursorType` type to set the cursor too. (You can also add the cursor to the stack)

Avaliable cursors:

```dart
enum CursorType {
  arrow,
  beamVertical,
  crossHair,
  closedHand,
  openHand,
  pointingHand,
  resizeLeft,
  resizeRight,
  resizeDown,
  resizeUp,
  resizeLeftRight,
  resizeUpDown,
  beamHorizontial,
  disappearingItem,
  notAllowed,
  dragLink,
  dragCopy,
  contextMenu,
}

```

```dart
WindowUtils.setCursor(CursorType cursor);
```

#### Add Mouse Cursor To Stack

> MACOS ONLY

Add a new cursor to the mouse cursor stack.

You need to provide `CursorType` type to set the cursor too. (You can also add the cursor to the stack)

Avaliable cursors:

```dart
enum CursorType {
  arrow,
  beamVertical,
  crossHair,
  closedHand,
  openHand,
  pointingHand,
  resizeLeft,
  resizeRight,
  resizeDown,
  resizeUp,
  resizeLeftRight,
  resizeUpDown,
  beamHorizontial,
  disappearingItem,
  notAllowed,
  dragLink,
  dragCopy,
  contextMenu,
}

```

```dart
WindowUtils.addCursorToStack(CursorType cursor);
```

#### Remove Cursor From Stack

This will remove the top cursor from the stack.

```dart
WindowUtils.removeCursorFromStack();
```

#### Hide Cursor(s)

This will hide the all the cursors in the stack.

```dart
WindowUtils.hideCursor();
```

#### Reset Cursor

This will reset the system cursor.

```dart
WindowUtils.resetCursor();
```

#### Show Cursor(s)

This will show all the cursors in the stack.

```dart
WindowUtils.showCursor();
```

## Example

```dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:window_utils/window_utils.dart';
import 'package:window_utils/window_frame.dart';

void main() {
  if (!kIsWeb && debugDefaultTargetPlatformOverride == null) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => WindowUtils.hideTitleBar(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: WindowsFrame(
        active: Platform.isWindows,
        border: Border.all(color: Colors.grey),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: GestureDetector(
                    onTapDown: (_) {
                      WindowUtils.startDrag();
                    },
                    onDoubleTap: () {
                      WindowUtils.windowTitleDoubleTap().then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                    child: Material(
                      elevation: 4.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Text(
                        'Window Utils Example',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            WindowUtils.getWindowSize()
                                .then((val) => print('Window: $val'));
                            WindowUtils.getScreenSize()
                                .then((val) => print('Screen: $val'));
                            WindowUtils.getWindowOffset()
                                .then((val) => print('Offset: $val'));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: InkWell(
            child: Icon(Icons.drag_handle),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Max Window Size"),
                trailing: IconButton(
                  icon: Icon(Icons.desktop_windows),
                  onPressed: () {
                    WindowUtils.getScreenSize().then((val) async {
                      await WindowUtils.setSize(Size(val.width, val.height));
                      await WindowUtils.setPosition(Offset(0, 0));
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("Increase Window Size"),
                trailing: IconButton(
                  icon: Icon(Icons.desktop_windows),
                  onPressed: () {
                    WindowUtils.getWindowSize().then((val) {
                      WindowUtils.setSize(
                        Size(val.width + 20, val.height + 20),
                      );
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("Move Window Position"),
                trailing: IconButton(
                  icon: Icon(Icons.drag_handle),
                  onPressed: () {
                    WindowUtils.getWindowOffset().then((val) {
                      WindowUtils.setPosition(
                        Offset(val.dx + 20, val.dy + 20),
                      );
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("Center Window"),
                trailing: IconButton(
                  icon: Icon(Icons.vertical_align_center),
                  onPressed: () {
                    WindowUtils.centerWindow();
                  },
                ),
              ),
              ListTile(
                title: Text("Close Window"),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    WindowUtils.closeWindow();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

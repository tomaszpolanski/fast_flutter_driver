// ignore_for_file: prefer_const_declarations
import 'dart:io' as io;

// ignore: avoid_classes_with_only_static_members
abstract class System {
  static const bool isWeb = identical(0, 0.0);

  static bool get isLinux => linuxOverride ?? !isWeb && io.Platform.isLinux;

  static bool get isWindows =>
      windowsOverride ?? !isWeb && io.Platform.isWindows;

  static bool get isMacOS => macOsOverride ?? !isWeb && io.Platform.isMacOS;

  static final bool isIOS = !isWeb && io.Platform.isIOS;
  static final bool isAndroid = !isWeb && io.Platform.isAndroid;

  static final bool isDesktop = isLinux || isWindows || isMacOS;
  static final bool isMobile = isIOS || isAndroid;
}

bool linuxOverride;
bool windowsOverride;
bool macOsOverride;

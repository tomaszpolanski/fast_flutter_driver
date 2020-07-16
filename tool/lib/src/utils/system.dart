// ignore_for_file: prefer_const_declarations
import 'dart:io' as io;

// ignore: avoid_classes_with_only_static_members
abstract class System {
  /// Whether the platform is Web
  static const bool isWeb = identical(0, 0.0);

  /// Whether the operating system is a version of
  /// [Linux](https://en.wikipedia.org/wiki/Linux).
  ///
  /// This value is `false` if the operating system is a specialized
  /// version of Linux that identifies itself by a different name,
  /// for example Android (see [isAndroid]).
  /// To override this property use [linuxOverride].
  static bool get isLinux => linuxOverride ?? !isWeb && io.Platform.isLinux;

  /// Whether the operating system is a version of
  /// [Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows).
  /// To override this property use [windowsOverride].
  static bool get isWindows =>
      windowsOverride ?? !isWeb && io.Platform.isWindows;

  /// Whether the operating system is a version of
  /// [macOS](https://en.wikipedia.org/wiki/MacOS).
  /// To override this property use [macOsOverride].
  static bool get isMacOS => macOsOverride ?? !isWeb && io.Platform.isMacOS;

  /// Whether the operating system is a version of
  /// [iOS](https://en.wikipedia.org/wiki/IOS).
  static final bool isIOS = !isWeb && io.Platform.isIOS;

  /// Whether the operating system is a version of
  /// [Android](https://en.wikipedia.org/wiki/Android_%28operating_system%29).
  static final bool isAndroid = !isWeb && io.Platform.isAndroid;

  /// Whether the platform is native desktop
  static final bool isDesktop = isLinux || isWindows || isMacOS;

  /// Whether the platform is native mobile
  static final bool isMobile = isIOS || isAndroid;
}

/// Used to override behavior of [System.isLinux]
bool linuxOverride;

/// Used to override behavior of [System.isWindows]
bool windowsOverride;

/// Used to override behavior of [System.isMacOS]
bool macOsOverride;

import 'dart:io' as io;

import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:test/test.dart';

void main() {
  group('isWeb', () {
    test('is', () {
      expect(System.isWeb, isTrue);
    }, skip: !System.isWeb);

    test('is not', () {
      expect(System.isWeb, isFalse);
    }, skip: System.isWeb);
  });

  group('isLinux', () {
    test('is', () {
      expect(System.isLinux, isTrue);
    }, skip: !System.isLinux);

    test('is not', () {
      expect(System.isLinux, isFalse);
    }, skip: System.isLinux);

    group('override', () {
      tearDown(() {
        linuxOverride = null;
      });

      test('when on linux', () {
        linuxOverride = false;
        expect(System.isLinux, isFalse);
      }, skip: !io.Platform.isLinux);

      test('when not on linux', () {
        linuxOverride = true;
        expect(System.isLinux, isTrue);
      }, skip: io.Platform.isLinux);
    });
  });

  group('isWindows', () {
    test('is', () {
      expect(System.isWindows, isTrue);
    }, skip: !System.isWindows);

    test('is not', () {
      expect(System.isWindows, isFalse);
    }, skip: System.isWindows);
  });

  group('isMacOS', () {
    test('is', () {
      expect(System.isMacOS, isTrue);
    }, skip: !System.isMacOS);

    test('is not', () {
      expect(System.isMacOS, isFalse);
    }, skip: System.isMacOS);
  });

  group('isIOS', () {
    test('is', () {
      expect(System.isIOS, isTrue);
    }, skip: !System.isIOS);

    test('is not', () {
      expect(System.isIOS, isFalse);
    }, skip: System.isIOS);
  });

  group('isAndroid', () {
    test('is', () {
      expect(System.isAndroid, isTrue);
    }, skip: !System.isAndroid);

    test('is not', () {
      expect(System.isAndroid, isFalse);
    }, skip: System.isAndroid);
  });

  group('isDesktop', () {
    test('is', () {
      expect(System.isDesktop, isTrue);
    }, skip: !System.isDesktop);

    test('is not', () {
      expect(System.isDesktop, isFalse);
    }, skip: System.isDesktop);
  });

  group('isMobile', () {
    test('is', () {
      expect(System.isMobile, isTrue);
    }, skip: !System.isMobile);

    test('is not', () {
      expect(System.isMobile, isFalse);
    }, skip: System.isMobile);
  });
}

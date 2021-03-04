## 2.0.0
- [BREAKING CHANGES] `flutter driver` is not yet migrated to sound null safety therefore you need to pass the following arguments:
```bash
fastdriver  --dart-args "--no-sound-null-safety" --flutter-args "--no-sound-null-safety"
```
- [FEATURE] Made `fastdriver` null safe

## 2.0.0-nullsafety.2
- When using Flutter version `1.26.0-17.8.pre` or higher you need to pass `--dart-args "--no-sound-null-safety" --flutter-args "--no-sound-null-safety"` parameters to `fastdriver` as `flutter driver` itself is not yet migrated
```bash
fastdriver  --dart-args "--no-sound-null-safety" --flutter-args "--no-sound-null-safety"
```

## 2.0.0-nullsafety.1
Pre-release for the null safety migration of this package.

Note that `1.5.0` may not be the final stable null safety release version,
we reserve the right to release it as a `2.0.0` breaking change.

This release will be pinned to only allow pre-release sdk versions starting
from `2.0.0`, which is the first version where this package will
appear in the null safety allow list.

## 1.5.1
- [FIX] Wrong version number reporting due to pub.dev page changes

## 1.5.0
- [ALPHA FEATURE] Supporting driver web tests
- [FIX] Package was not able to detect new version due to pub.dev changing

## 1.4.0
- [FEATURE] Allowing to pass additional arguments to `flutter run` command via `--flutter-args` command eg `fastdriver --flutter-args --enable-experiment:non-nullable`
- [FEATURE] Allowing to pass additional arguments to `dart` command via `--dart-args` command eg `fastdriver --dart-args --enable-experiment=non-nullable`
- [FEATURE] Allowing to pass additional arguments to tests. 
If you want to implement passing for example language that the app should be run, then you can run `fastdriver --test-args "--language pl"`.
Your tests will not receive in `TestProperties::additionalArgs` `--language pl` that can be used to set up your tests and app.

## 1.3.3
- [FEATURE] Tests in `generic_test.dart::main` are sorted by name in case users want to run the tests in a specific order

## 1.3.2+1
- Updating example to Flutter `1.22.0-12.1.pre`

## 1.3.2
- [FIX] Not throwing an exception when inputting unknown command
- [FIX] Not being able to run tests from some directories on Windows

## 1.3.0
- [FEATURE] Supporting Flutter 1.20
- [FIX] Notification about new package update not working due to pub.dev changing it's html layout

## 1.2.0+2
- [CLEANUP] Cleaning up and adding more documentation

## 1.2.0
- [FEATURE] Passing `flavor` parameter when running tests

## 1.1.1
- [FIX] Running subfolder tests failed

## 1.1.0
- Exposing System helper class

## 1.0.0+3
- Removing duplication of update message

## 1.0.0+2
- Increasing test coverage and refactoring

## 1.0.0+1
- (@akaiser) Fixing a typo
- Updating README

## 1.0.0
- Promoting stable version

## 0.3.0+3
-  Supporting dynamic window resizing for Windows

## 0.3.0+2
- Supporting changing resolution on Windows in Flutter 1.19.+

## 0.3.0+1
- Fixing bug when the first `generic.dart` config file was picked up instead of the one from specified folder

## 0.3.0
- Allowing execution tests in subfolder eg. `test_driver/page1/`
- **BRAKING CHANGE** you need to run `fastdriver` from the root directory of your project - the directory that contains `pubspec.yaml`

## 0.2.2+2
- Removing debug `print`

## 0.2.2+1
- Fixing running of a single file inside a subfolder eg. `test_driver/page1/simple_test.dart`

## 0.2.2
- Fixing resolution changes for Linux for `1.15.17`+

## 0.2.1+3
- Not printing `VMServiceFlutterDriver` (happening on version `1.15.17`+) lines when running tests 


## 0.2.1+2
- Removing debug `print`

## 0.2.1+1
- Improving lookup of already installed script version

## 0.2.1
- New version available notification

## 0.2.0
- Removing `-f` and replacing `-d` option. Just passing a file or folder to `fastdirver` without any flags, will run that file/directory
- Allowing to run fast tests on mobile device by using `-d` or `--device` option

## 0.1.0+1
- Updating the documentation

## 0.1.0
- Releasing stable version

## 0.0.6
- Removing the need for specifying `-f` or `-d` 

## 0.0.5+1
- Fixing aggregated test lookup
- Improved error loggin

## 0.0.5
- Returning error code when tests fail

## 0.0.4+1
- Release cleanup

## 0.0.4
- Making logging less verbose (#15)
- Not needing to create `generic_test.dart` file (#14)
- Removing not needed dependencies

## 0.0.3
- Improving logging

## 0.0.2
- Updating package setup

## 0.0.1
- Initial version

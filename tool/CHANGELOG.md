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

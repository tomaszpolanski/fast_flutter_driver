## 2.0.0-nullsafety.1

Pre-release for the null safety migration of this package.

Note that `1.3.0` may not be the final stable null safety release version,
we reserve the right to release it as a `2.0.0` breaking change.

This release will be pinned to only allow pre-release sdk versions starting
from `2.0.0`, which is the first version where this package will
appear in the null safety allow list.

## 1.3.0
- [ALPHA FEATURE] Initial (ALPHA) support for web driver

## 1.2.0
- [FEATURE] Added `TestProperties::additionalArgs` that allows passing arguments to the tests. 
If you want to implement passing for example language that the app should be run, then you can run `fastdriver --test-args "--language pl"`.
Your tests will not receive in `TestProperties::additionalArgs` `--language pl` that can be used to set up your tests and app.


## 1.1.0+1
- Updating example to Flutter `1.22.0-12.1.pre`

## 1.1.0
- [FIX] Do not override platform when the `-p` is not passed.

## 1.0.1
- Improving testability

## 1.0.0+3
- Updating documentation

## 1.0.0+2
- Increasing test coverage and refactoring

## 1.0.0+1
- Updating README

## 1.0.0
- Promoting stable version

## 0.1.2
- Supporting dynamic window resizing for Windows

## 0.1.1+2
- Enabled iOS fastdriver tests

## 0.1.1+1
- Updating Fast Flutter Driver tool dependency version

## 0.1.1
- Updating Fast Flutter Driver tool dependency version

## 0.1.0
- Embedding [windows_utils](https://pub.dev/packages/window_utils) due to an issue in Linux

## 0.0.2

- Adding `Delayed` widget to help with debugging

## 0.0.1

- Initial version

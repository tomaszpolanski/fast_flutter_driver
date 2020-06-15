# Fast Flutter Driver example

An example of how to use Fast Flutter Driver.
This example can be run on a mobile device/emulator/simulator or on desktop.

## Installation
- Get [fast_flutter_driver](https://github.com/tomaszpolanski/fast_flutter_driver) command line tool:
```shell script
pub global activate fast_flutter_driver_tool
```

## Running on Mobile
To run the tests on a specific device, just pass the device id that you get from `flutter devices`:
```
fastdriver --device emulator-5554
```

## Enabling and running on Desktop
You need first to setup Flutter for desktop if you had not done it before.

### Enable desktop builds

Latest tested version of Flutter that works with this repo is `1.19.0-4.1.pre`:
  * **Important**: Use `version` otherwise desktop won't be picked up: `1.19.0-4.1.pre`

#### Linux
- Add the following to `.bash_profile` but replace `$HOME/flutter/` with path to your Flutter folder
```
# Add Flutter
export PATH="$PATH:$HOME/flutter/bin"
# Add Dart
export PATH="$PATH:$HOME/flutter/bin/cache/dart-sdk/bin"
```
#### Mac
- Add the following to `.bash_profile` but replace `$HOME/flutter/` with path to your Flutter folder
```
# Add Flutter
export PATH="$PATH:$HOME/flutter/bin"
# Add Dart
export PATH="$PATH:$HOME/flutter/bin/cache/dart-sdk/bin"
```
- Update CocoaPods:
```
brew upgrade cocoapods
pod setup
gem install cocoapods
```
- In case you are getting error `ArgumentError - invalid byte sequence in US-ASCII` when installing Pods, set proper encoding:
```
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```
#### Windows
- Install Visual Studio Community 2019 with [Desktop development with C++](https://devblogs.microsoft.com/cppblog/windows-desktop-development-with-c-in-visual-studio/#installation). 
Make sure that those components are installed:
* `MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.23)`   
* `Windows 10 SDK (10.0.17763.0)` 


### Running on Desktop
If you don't specify the device you want to run the tests against, then desktop device is used by default:
```bash
fastdriver
```

## How to write your tests
All tests located files that end with `_test.dart` in `test_driver` folder will be run in separation.

Check out [simple_test.dart](test_driver/simple_test.dart) to see the basic structure of a test.
# Fast Flutter Driver example

An example on how to use Fast Flutter Driver

## Enable desktop builds

Last tested version of Flutter that works with this repo is `v1.14.6`:
  * **Important**: Use `version` otherwise desktop won't be picked up: `v1.14.6`

Enable desktop builds by running in the terminal:
```
flutter config --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop
```
### Linux
- Add the following to `.bash_profile` but replace `$HOME/flutter/` with path to your Flutter folder
```
# Add Flutter
export PATH="$PATH:$HOME/flutter/bin"
# Add Dart
export PATH="$PATH:$HOME/flutter/bin/cache/dart-sdk/bin"
```
### Mac
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
### Windows
- Install Visual Studio Community 2019 with [Desktop development with C++](https://devblogs.microsoft.com/cppblog/windows-desktop-development-with-c-in-visual-studio/#installation). 
Make sure that those components are installed:
* `MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.23)`	
* `Windows 10 SDK (10.0.17763.0)` 


## Running the tests
- Install [fast_flutter_driver](https://github.com/tomaszpolanski/fast_flutter_driver) script:
```shell script
pub global activate fast_flutter_driver_tool
```
- Run:
```
fastdriver
```

To run the tests on a specyfic device like an emulator just pass the device id that you get from `flutter devices`:
```
fastdriver --device emulator-5554
```
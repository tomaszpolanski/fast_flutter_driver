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
```bash
flutter pub get
fastdriver --device emulator-5554
```

## Enabling and running on Desktop
You need first to setup Flutter for desktop if you had not done it before.
Latest tested version of Flutter that works with this repo is `1.20.0-7.2.pre`.

### Enable desktop builds

* Checkout the latest changes in Flutter by running `flutter channel master` OR going into Flutter folder and running `git pull`
* **Important**: Use `version` otherwise desktop won't be picked up: `flutter version 1.20.0-7.2.pre`
* Run `flutter config --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop`
* Check what desktop components are missing by running `flutter doctor`
* Install missing components that you can see under Flutter doctor's  `Linux`/`Window`/`MacOS` section


### Running on Desktop
If you don't specify the device you want to run the tests against, then desktop device is used by default:
```bash
flutter pub get
fastdriver
```


### Running on Docker
1) Install `docker`
2) Build docker image (will take a couple of minutes)
```
./build_docker.sh 1.20.2 ./
```
3) Run docker container and get it's `id`
```
docker run -d tomek/flutter:latest
```
4) Start X11 UI
```
docker exec -d <containerId> sh -c "Xvfb :0 -screen 0 1920x1920x24"
```
5) Execute Flutter tests

```
docker exec <containerId> sh -c "cd /home/user/fast_flutter_driver/example && fastdriver -r 1600x1200"
```


## How to write your tests
All tests located files that end with `_test.dart` in `test_driver` folder will be run in separation.

Check out [simple_test.dart](test_driver/simple_test.dart) to see the basic structure of a test.

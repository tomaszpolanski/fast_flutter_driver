import Flutter
import UIKit

public class SwiftFastFlutterDriverPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fast_flutter_driver", binaryMessenger: registrar.messenger())
    let instance = SwiftFastFlutterDriverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

#import "FastFlutterDriverPlugin.h"
#if __has_include(<fast_flutter_driver/fast_flutter_driver-Swift.h>)
#import <fast_flutter_driver/fast_flutter_driver-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fast_flutter_driver-Swift.h"
#endif

@implementation FastFlutterDriverPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFastFlutterDriverPlugin registerWithRegistrar:registrar];
}
@end

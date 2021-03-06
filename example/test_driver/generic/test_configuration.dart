import 'package:fast_flutter_driver/tool.dart';

/// To this file you can add any serializable parameters.
/// This configuration will passed to you Flutter application and you can
/// use it to setup the state of your app, e.g. setup language,
/// change UI to iOS or Android, login users or even mock endpoints
/// with responses
class TestConfiguration implements BaseConfiguration {
  const TestConfiguration({
    required this.resolution,
    this.platform,
    required this.route,
  });

  factory TestConfiguration.fromJson(Map<String, dynamic> json) {
    return TestConfiguration(
      resolution: Resolution.fromJson(json['resolution']),
      platform: TestPlatformEx.fromString(json['platform']),
      route: json['route'],
    );
  }

  @override
  final TestPlatform? platform;
  @override
  final Resolution resolution;
  final String route;

  @override
  Map<String, dynamic> toJson() {
    final p = platform;
    return <String, dynamic>{
      'resolution': resolution,
      if (p != null) 'platform': p.asString(),
      'route': route,
    };
  }
}

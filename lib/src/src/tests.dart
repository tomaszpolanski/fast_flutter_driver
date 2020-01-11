import 'package:args/args.dart';
import 'package:fast_flutter_driver/src/src/parameters.dart';
import 'package:fast_flutter_driver/src/src/resolution.dart';
import 'package:fast_flutter_driver/src/src/url_matcher.dart';
import 'package:meta/meta.dart';

const url = 'url';
const screenshots = 'screenshots';
const resolutionArg = 'resolution';
const languageArg = 'language';
const platformArg = 'platform';

ArgParser testParser = ArgParser()
  ..addOption(
    url,
    abbr: url[0],
    help: 'Url for dartVmServiceUrl',
  )
  ..addOption(
    resolutionArg,
    abbr: resolutionArg[0],
    help: 'Resolution of device',
  )
  ..addFlag(
    screenshots,
    abbr: screenshots[0],
    help: 'Use screenshots',
  )
  ..addOption(
    languageArg,
    abbr: languageArg[0],
    defaultsTo: 'en',
    help: 'Language of the device',
  )
  ..addOption(
    platformArg,
    abbr: platformArg[0],
    help: 'Overwritten platform of the device',
  );

class TestProperties {
  TestProperties(List<String> args) : _arguments = testParser.parse(args);

  final ArgResults _arguments;

  String get vmUrl => _arguments[url];

  bool get screenshotsEnabled => _arguments[screenshots] ?? false;

  Resolution get resolution => Resolution.fromSize(_arguments[resolutionArg]);

  TestPlatform get platform => platformFromString(_arguments[platformArg]);
}

class TestConfiguration {
  const TestConfiguration({
    @required this.locale,
    @required this.resolution,
    this.platform,
    this.route,
    this.matchers = const [],
    this.filePicker,
  });

  factory TestConfiguration.fromJson(Map<String, dynamic> json) {
    final List<dynamic> matchers = json['matchers'];
    final List<dynamic> filePicker = json['filePicker'];
    return TestConfiguration(
      locale: json['locale'],
      resolution: Resolution.fromJson(json['resolution']),
      platform: platformFromString(json['platform']),
      route: TestRoute.fromJson(json['route']),
      matchers: matchers?.map((it) => TestMatcher.fromJson(it))?.toList() ?? [],
      filePicker: filePicker?.cast<String>() ?? [],
    );
  }

  final String locale;
  final Resolution resolution;
  final TestPlatform platform;
  final TestRoute route;
  final List<TestMatcher> matchers;
  final List<String> filePicker;

  TestConfiguration copyWith({
    String locale,
    Resolution resolution,
    TestPlatform platform,
    TestRoute route,
    List<TestMatcher> matchers,
    List<String> filePicker,
  }) {
    return TestConfiguration(
      locale: locale ?? this.locale,
      resolution: resolution ?? this.resolution,
      platform: platform ?? this.platform,
      route: route ?? this.route,
      matchers: matchers ?? this.matchers,
      filePicker: filePicker ?? this.filePicker,
    );
  }

  Map<String, dynamic> toJson() => {
        'locale': locale,
        'resolution': resolution,
        if (platform != null) 'platform': fromEnum(platform),
        'route': route.toJson(),
        'matchers': matchers,
        'filePicker': filePicker,
      };
}

class TestMatcher {
  const TestMatcher(this.matcher, {this.request});

  factory TestMatcher.fromJson(Map<String, dynamic> json) {
    return TestMatcher(
      UrlMatcher.fromJson(json['matcher']),
      request: TestRequest.fromJson(json['request']),
    );
  }

  final UrlMatcher matcher;
  final TestRequest request;

  Map<String, dynamic> toJson() => {
        'matcher': matcher,
        'request': request,
      };
}

class TestRoute {
  const TestRoute({
    this.route,
    this.parameters,
  });

  factory TestRoute.fromJson(Map<String, dynamic> json) {
    return TestRoute(
      route: json['route'],
      parameters: Map<String, String>.from(json['parameters'] ?? {}),
    );
  }

  final String route;
  final Map<String, String> parameters;

  Map<String, dynamic> toJson() => {
        'route': route,
        'parameters': parameters,
      };
}

class TestRequest {
  const TestRequest({
    this.code = 200,
    this.file,
    this.page,
    this.delayed = false,
    this.replace,
  });

  factory TestRequest.fromJson(Map<String, dynamic> json) {
    return TestRequest(
      code: json['code'],
      file: json['file'],
      page: json['page'],
      delayed: json['delayed'],
      replace: Map<String, String>.from(json['replace'] ?? {}),
    );
  }

  final int code;
  final String file;
  final int page;
  final bool delayed;
  final Map<String, String> replace;

  Map<String, dynamic> toJson() => {
        'code': code,
        'file': file,
        'page': page,
        'delayed': delayed,
        'replace': replace,
      };
}

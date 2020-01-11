String fromEnum(Object enumeration) {
  assert(enumeration != null, 'Enumeration object cannot be null');
  return enumeration.toString().split('.').last;
}

enum TestPlatform {
  android,
  iOS,
}

abstract class TestPlatformEx {
  static TestPlatform fromString(String value) {
    switch (value?.toLowerCase()) {
      case 'android':
        return TestPlatform.android;
      case 'ios':
        return TestPlatform.iOS;
      default:
        return null;
    }
  }
}

import 'main_test.dart' as main_test;
import 'preparing_tests/commands_test.dart' as commands_test;
import 'preparing_tests/testing_test.dart' as testing_test;
import 'update/version_test.dart' as version_test;
import 'utils/enum_test.dart' as enum_test;

void main() {
  main_test.main();
  commands_test.main();
  testing_test.main();
  version_test.main();
  enum_test.main();
}

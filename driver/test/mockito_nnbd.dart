import 'package:mockito/mockito.dart' as mockito;

dynamic get any => mockito.any;
dynamic get captureAny => mockito.captureAny;
dynamic anyNamed(String named) => mockito.anyNamed(named);
dynamic captureAnyNamed(String named) => mockito.captureAnyNamed(named);

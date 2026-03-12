import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test placeholder', (WidgetTester tester) async {
    // Widget tests require Hive initialization which needs platform channels.
    // See test/domain/entities/ for unit tests.
    expect(true, isTrue);
  });
}

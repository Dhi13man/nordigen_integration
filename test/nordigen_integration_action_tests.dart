import 'package:test/test.dart';

import './nordigen_integration_test.dart' show accessToken;

void main() {
  /// TEST 0
  test(
    'Ensure that Access Token has been reset.',
    () => expect(accessToken, 'YOUR_TOKEN'),
  );
}

import 'package:flutter_test/flutter_test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

void main() {
  final String accessToken = 'API_CODE';
  test('Simulate and Test Step 1: Initialize with Access Token', () {
    bool isClassInitSuccessful = true;
    try {
      NordigenAccountInfoAPI(accessToken: accessToken);
    } catch (_) {
      isClassInitSuccessful = false;
    }
    expect(isClassInitSuccessful, true);
  });
  test('Simulate and Test Step 2: Choose a Bank', () async {
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    final List<ASPSP> aspsps = await nordigenObject.getBanksForCountry('gb');
    expect(aspsps.length > 0, true);
  });
}

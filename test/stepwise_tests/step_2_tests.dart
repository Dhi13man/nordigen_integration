import 'package:flutter_test/flutter_test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 2 of Nordigen API integration.
/// 
/// Pass in Nordigen Access Token [accessToken] to the function.
void step2Tests({required String accessToken}) {
  /// TEST 2.1
  test('Simulate Step 2: Choose a Bank/ASPSP', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Make Request
    final List<ASPSP> aspsps =
        await nordigenObject.getASPSPsForCountry(countryCode: 'gb');
    // Should not be empty as we have 'gb' country-code ASPSPs
    expect(aspsps.isNotEmpty, true);
  });

  /// TEST 2.2
  test('GET a single ASPSP by ID', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Make Request
    final List<ASPSP> aspsps =
        await nordigenObject.getASPSPsForCountry(countryCode: 'gb');
    // Should not be empty as we have 'gb' country-code ASPSPs
    expect(aspsps.isNotEmpty, true);
    final ASPSP singleASPSP =
        await nordigenObject.getASPSPUsingID(aspspID: aspsps.first.id);
    // Verify ASPSP recieved. Integrity check
    expect(aspsps.first.toString(), singleASPSP.toString());
  });
}

import 'package:test/test.dart';

import 'package:nordigen_integration/nordigen_integration.dart';

/// Tests associated with Step 2 of Nordigen API integration.
///
/// Pass in Nordigen Access Token [accessToken] to the function.
void step2Tests({required String accessToken}) {
  /// TEST 2.1
  test('Simulate Step 2: Choose a Bank/Institution', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Make Request
    final List<Institution> institutions =
        await nordigenObject.getInstitutionsForCountry(countryCode: 'gb');
    // Should not be empty as we have 'gb' country-code Institutions
    expect(institutions.isNotEmpty, true);
  });

  /// TEST 2.2
  test('GET a single Institution by ID', () async {
    // API and Parameters Set up
    final NordigenAccountInfoAPI nordigenObject =
        NordigenAccountInfoAPI(accessToken: accessToken);
    // Make Request
    final List<Institution> institutions =
        await nordigenObject.getInstitutionsForCountry(countryCode: 'gb');
    // Should not be empty as we have 'gb' country-code Institutions
    expect(institutions.isNotEmpty, true);
    final Institution singleInstitution =
        await nordigenObject.getInstitutionUsingID(institutionID: institutions.first.id);

    print(singleInstitution.logoURL);
    // Verify Institution recieved. Integrity check
    expect(institutions.first.toString(), singleInstitution.toString());
  });
}
